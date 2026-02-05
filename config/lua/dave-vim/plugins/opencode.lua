local setup = function()
    vim.g.opencode_opts = {
        port = 6999,
        provider = {
            enabled = "tmux",
        },
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true

    -- Register with which-key for better discoverability
    -- Schedule to run after which-key is loaded
    vim.schedule(function()
        local ok, wk = pcall(require, "which-key")
        if ok then
            wk.add({
                -- Main group
                { "<leader>a", group = "AI/OpenCode" },

                -- Core operations
                { "<leader>as", desc = "Ask OpenCode with context" },
                { "<leader>ax", desc = "Select OpenCode operation" },

                -- Context-aware prompts group
                { "<leader>a", group = "Prompts", mode = "n" },
                { "<leader>ae", desc = "Explain code" },
                { "<leader>af", desc = "Find bugs" },
                { "<leader>ar", desc = "Refactor code" },
                { "<leader>at", desc = "Write tests" },

                -- Session management group
                { "<leader>an", desc = "New session" },
                { "<leader>al", desc = "List sessions" },
                { "<leader>ac", desc = "Clear session" },

                -- Text operators
                { "<leader>ao", desc = "Add range to OpenCode" },
                { "<leader>aoo", desc = "Add current line to OpenCode" },

                -- Mode switching
                { "<leader>ab", desc = "Switch to Build mode" },
                { "<leader>ap", desc = "Switch to Plan mode" },

                -- Navigation
                { "<leader>ak", desc = "Scroll OpenCode up" },
                { "<leader>aj", desc = "Scroll OpenCode down" },

                -- Telescope integration
                { "<leader>aF", desc = "Search files for OpenCode" },
                { "<leader>aG", desc = "Grep for OpenCode context" },
                { "<leader>aB", desc = "Select buffers for OpenCode" },
            })
        end
    end)
end

-- ============================================================================
-- TELESCOPE INTEGRATION HELPERS
-- ============================================================================
-- Functions to bridge Telescope pickers with OpenCode context
-- ============================================================================

-- Format selected files/entries for OpenCode
local format_selections_for_opencode = function(selections, prompt_prefix)
    if not selections or #selections == 0 then
        return nil
    end

    local file_refs = {}
    for _, entry in ipairs(selections) do
        -- Handle different entry types from Telescope
        local path = entry.path or entry.filename or entry.value
        if path then
            -- Use relative path for cleaner refs
            local relative = vim.fn.fnamemodify(path, ":.")
            table.insert(file_refs, "@" .. relative)
        end
    end

    if #file_refs == 0 then
        return nil
    end

    -- Build prompt with file references
    local files_str = table.concat(file_refs, " ")
    local prompt = prompt_prefix or ""

    return prompt .. files_str .. ": "
end

-- Open Telescope file picker and send selections to OpenCode
local telescope_files_to_opencode = function()
    local ok, telescope = pcall(require, "telescope")
    if not ok then
        vim.notify("Telescope not available", vim.log.levels.ERROR)
        return
    end

    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    pickers
        .new({}, {
            prompt_title = "Select Files for OpenCode (Tab to multi-select)",
            finder = finders.new_oneshot_job({ "fd", "--type", "f", "--hidden", "--exclude", ".git" }, {}),
            sorter = conf.file_sorter({}),
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    local picker = action_state.get_current_picker(prompt_bufnr)
                    local selections = picker:get_multi_selection()

                    -- If no multi-selection, use current selection
                    if #selections == 0 then
                        local selection = action_state.get_selected_entry()
                        if selection then
                            selections = { selection }
                        end
                    end

                    actions.close(prompt_bufnr)

                    local prompt = format_selections_for_opencode(selections, "")
                    if prompt then
                        require("opencode").ask(prompt, { submit = false })
                    else
                        vim.notify("No files selected", vim.log.levels.WARN)
                    end
                end)

                return true
            end,
        })
        :find()
end

-- Open Telescope grep and send results to OpenCode
local telescope_grep_to_opencode = function()
    local ok, telescope = pcall(require, "telescope")
    if not ok then
        vim.notify("Telescope not available", vim.log.levels.ERROR)
        return
    end

    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    -- Start with live_grep picker
    require("telescope.builtin").live_grep({
        prompt_title = "Grep for OpenCode (Tab to multi-select files)",
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local picker = action_state.get_current_picker(prompt_bufnr)
                local selections = picker:get_multi_selection()

                if #selections == 0 then
                    local selection = action_state.get_selected_entry()
                    if selection then
                        selections = { selection }
                    end
                end

                actions.close(prompt_bufnr)

                -- Extract unique files from grep results
                local files = {}
                local file_set = {}
                for _, entry in ipairs(selections) do
                    local filepath = entry.filename or entry.path
                    if filepath and not file_set[filepath] then
                        file_set[filepath] = true
                        table.insert(files, { path = filepath })
                    end
                end

                local prompt = format_selections_for_opencode(files, "")
                if prompt then
                    require("opencode").ask(prompt, { submit = false })
                else
                    vim.notify("No matches selected", vim.log.levels.WARN)
                end
            end)

            return true
        end,
    })
end

-- Open Telescope buffer picker and send to OpenCode
local telescope_buffers_to_opencode = function()
    local ok, telescope = pcall(require, "telescope")
    if not ok then
        vim.notify("Telescope not available", vim.log.levels.ERROR)
        return
    end

    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    require("telescope.builtin").buffers({
        prompt_title = "Select Buffers for OpenCode (Tab to multi-select)",
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local picker = action_state.get_current_picker(prompt_bufnr)
                local selections = picker:get_multi_selection()

                if #selections == 0 then
                    local selection = action_state.get_selected_entry()
                    if selection then
                        selections = { selection }
                    end
                end

                actions.close(prompt_bufnr)

                local prompt = format_selections_for_opencode(selections, "")
                if prompt then
                    require("opencode").ask(prompt, { submit = false })
                else
                    vim.notify("No buffers selected", vim.log.levels.WARN)
                end
            end)

            return true
        end,
    })
end

local keys = {
    -- ============================================================================
    -- OPENCODE KEYBINDINGS
    -- ============================================================================
    -- All OpenCode commands use the <leader>a prefix
    -- Organized into groups: Prompts, Sessions, Operators, Modes, Navigation
    -- ============================================================================

    { "<leader>a", nil, desc = "AI/OpenCode" },

    -- ----------------------------------------------------------------------------
    -- CORE OPERATIONS
    -- ----------------------------------------------------------------------------
    {
        "<leader>as",
        function()
            require("opencode").ask("@this: ", { submit = true })
        end,
        desc = "Ask OpenCode with context",
    },
    {
        "<leader>ax",
        function()
            require("opencode").select()
        end,
        desc = "Select OpenCode operation",
    },

    -- ----------------------------------------------------------------------------
    -- CONTEXT-AWARE PROMPTS
    -- ----------------------------------------------------------------------------
    -- Quick access to common AI tasks with automatic context (@this)
    {
        "<leader>ae",
        function()
            require("opencode").ask("Explain this code: @this", { submit = true })
        end,
        desc = "Explain code",
    },
    {
        "<leader>af",
        function()
            require("opencode").ask("Review this code for bugs, errors, and potential issues: @this", { submit = true })
        end,
        desc = "Find bugs",
    },
    {
        "<leader>ar",
        function()
            require("opencode").ask("Refactor and improve this code: @this", { submit = true })
        end,
        desc = "Refactor code",
    },
    {
        "<leader>at",
        function()
            require("opencode").ask("Write comprehensive tests for: @this", { submit = true })
        end,
        desc = "Write tests",
    },

    -- ----------------------------------------------------------------------------
    -- SESSION MANAGEMENT
    -- ----------------------------------------------------------------------------
    -- Manage OpenCode conversation sessions
    {
        "<leader>an",
        function()
            require("opencode").command("session.new")
        end,
        desc = "New session",
    },
    {
        "<leader>al",
        function()
            require("opencode").command("session.list")
        end,
        desc = "List sessions",
    },
    {
        "<leader>ac",
        function()
            require("opencode").command("session.clear")
        end,
        desc = "Clear session",
    },

    -- ----------------------------------------------------------------------------
    -- TEXT OPERATORS
    -- ----------------------------------------------------------------------------
    -- Add code ranges/lines to OpenCode context
    {
        "<leader>ao",
        function()
            return require("opencode").operator("@this ")
        end,
        desc = "Add range to OpenCode",
        expr = true,
    },
    {
        "<leader>aoo",
        function()
            return require("opencode").operator("@this ") .. "_"
        end,
        desc = "Add current line to OpenCode",
        expr = true,
    },

    -- ----------------------------------------------------------------------------
    -- MODE SWITCHING
    -- ----------------------------------------------------------------------------
    -- Switch between Plan mode (read-only) and Build mode (can edit)
    {
        "<leader>ab",
        function()
            require("opencode").command("mode.build")
        end,
        desc = "Switch to Build mode",
    },
    {
        "<leader>ap",
        function()
            require("opencode").command("mode.plan")
        end,
        desc = "Switch to Plan mode",
    },

    -- ----------------------------------------------------------------------------
    -- NAVIGATION
    -- ----------------------------------------------------------------------------
    -- Scroll through OpenCode output
    {
        "<leader>ak",
        function()
            require("opencode").command("session.half.page.up")
        end,
        desc = "Scroll OpenCode up",
    },
    {
        "<leader>aj",
        function()
            require("opencode").command("session.half.page.down")
        end,
        desc = "Scroll OpenCode down",
    },

    -- ----------------------------------------------------------------------------
    -- TELESCOPE INTEGRATION
    -- ----------------------------------------------------------------------------
    -- Use Telescope to search and add files/code to OpenCode context
    {
        "<leader>aF",
        function()
            telescope_files_to_opencode()
        end,
        desc = "Search files for OpenCode",
    },
    {
        "<leader>aG",
        function()
            telescope_grep_to_opencode()
        end,
        desc = "Grep for OpenCode context",
    },
    {
        "<leader>aB",
        function()
            telescope_buffers_to_opencode()
        end,
        desc = "Select buffers for OpenCode",
    },
}

return {
    lazy = function()
        return {
            "opencode.nvim",
            after = setup,
            keys = keys,
        }
    end,
}
