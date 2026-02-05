local setup = function()
    vim.g.opencode_opts = {
        port = 6999,
        provider = {
            enabled = "tmux",
        },

        -- ========================================================================
        -- CONFIGURATION OPTIONS
        -- ========================================================================
        -- Model selection, permissions, UI preferences, and behavior settings
        -- ========================================================================

        -- Model configuration
        model = "anthropic/claude-sonnet-4-5",        -- Default model for complex tasks
        small_model = "anthropic/claude-haiku-4-5",   -- Fast model for lightweight tasks (titles, summaries)

        -- Permission system (safety-first approach)
        permission = {
            bash = "ask",      -- Ask before running shell commands (security)
            write = "ask",     -- Ask before creating new files (safety)
            edit = "allow",    -- Allow editing existing files without asking
        },

        -- TUI (Terminal UI) preferences
        tui = {
            scroll_speed = 3,                    -- Scroll speed multiplier (1-10, default: 3)
            scroll_acceleration = {
                enabled = true,                   -- macOS-style smooth scroll acceleration
            },
            diff_style = "auto",                 -- "auto" (adapts to width) or "stacked" (single column)
        },

        -- Context management
        compaction = {
            auto = true,       -- Automatically compact context when full
            prune = true,      -- Remove old tool outputs to save tokens
        },

        -- Auto-update behavior (Nix-friendly)
        autoupdate = "notify",    -- Options: true (auto), false (never), "notify" (check but don't install)

        -- Theme selection
        theme = "opencode",       -- Default OpenCode theme

        -- Sharing preferences
        share = "manual",         -- Options: "manual" (explicit /share), "auto", "disabled"

        -- File watcher ignore patterns
        watcher = {
            ignore = {
                "node_modules/**",
                "target/**",
                ".git/**",
                "result/**",           -- Nix build outputs
                ".direnv/**",          -- direnv cache
                "*.log",
                "*.tmp",
            },
        },

        -- Instructions/rules (automatically loaded into context)
        instructions = {
            "README.md",
            "CONTRIBUTING.md",
            ".opencode/rules/*.md",
        },

        -- ========================================================================
        -- CUSTOM SPECIALIZED AGENTS
        -- ========================================================================
        -- Three domain-expert agents optimized for specific workflows
        -- ========================================================================
        agent = {
            ["nix-expert"] = {
                description = "Nix and NixOS configuration expert",
                prompt = [[You are a Nix expert specializing in:
- Nix flakes and flake.nix structure
- Package management and derivations  
- NixOS configuration and modules
- Reproducible development environments
- Best practices for declarative systems

Focus on:
- Reproducibility and declarative patterns
- Avoiding impure operations
- Proper dependency management
- Performance optimization
- Common pitfalls and anti-patterns

When helping with code:
- Explain the Nix evaluation model
- Show both the problem and the solution
- Reference official Nix documentation
- Suggest modern patterns over legacy approaches]],
                model = "anthropic/claude-sonnet-4-5",
            },

            ["neovim-expert"] = {
                description = "Neovim plugin development and Lua configuration expert",
                prompt = [[You are a Neovim and Lua expert specializing in:
- Neovim plugin architecture and APIs
- Lua programming for Neovim
- Lazy-loading patterns (especially lz.n)
- Plugin configuration best practices
- Performance optimization

Focus on:
- Modern Neovim APIs (vim.lsp, vim.diagnostic, vim.keymap, etc.)
- Efficient lazy-loading strategies
- Clean plugin module patterns
- Integration with existing plugin ecosystem
- Avoiding deprecated APIs (use vim.* over vim.fn where possible)

When helping with code:
- Prefer modern APIs over legacy vimscript
- Explain lazy-loading implications
- Show efficient patterns
- Consider startup time impact]],
                model = "anthropic/claude-sonnet-4-5",
            },

            ["code-reviewer"] = {
                description = "Code quality and best practices reviewer (read-only)",
                prompt = [[You are an expert code reviewer focusing on:
- Security vulnerabilities and risks
- Performance bottlenecks
- Code maintainability and readability
- Design patterns and anti-patterns
- Testing coverage and quality
- Documentation completeness

Provide:
- Specific, actionable feedback
- Severity ratings (Critical, High, Medium, Low)
- Code examples for improvements
- Explanation of WHY changes are recommended
- Prioritized list of issues (most important first)

Review philosophy:
- Be constructive, not critical
- Explain the reasoning behind suggestions
- Consider context and constraints
- Balance perfection with pragmatism

IMPORTANT: You are in read-only mode. Suggest changes but do not implement them.]],
                model = "anthropic/claude-haiku-4-5",
                tools = {
                    -- Disable modification tools for safety
                    write = false,
                    edit = false,
                    bash = false,
                },
            },
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

                -- Neo-tree integration (when in Neo-tree buffer)
                { "<leader>aa", desc = "Add Neo-tree node to OpenCode (in Neo-tree)" },
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

-- ============================================================================
-- NEO-TREE INTEGRATION HELPER
-- ============================================================================
-- Function to add Neo-tree selected node to OpenCode context
-- ============================================================================

-- Add current Neo-tree node to OpenCode
local neotree_node_to_opencode = function()
    -- Check if Neo-tree is available
    local ok, neotree_manager = pcall(require, "neo-tree.sources.manager")
    if not ok then
        vim.notify("Neo-tree not available", vim.log.levels.ERROR)
        return
    end

    -- Get the current Neo-tree state
    local state = neotree_manager.get_state("filesystem")
    if not state then
        vim.notify("Neo-tree is not open", vim.log.levels.WARN)
        return
    end

    -- Get the currently selected node
    local tree = state.tree
    if not tree then
        vim.notify("No Neo-tree tree found", vim.log.levels.WARN)
        return
    end

    local node = tree:get_node()
    if not node then
        vim.notify("No node selected in Neo-tree", vim.log.levels.WARN)
        return
    end

    -- Get the file path
    local path = node:get_id()
    if not path or path == "" then
        vim.notify("Invalid node path", vim.log.levels.WARN)
        return
    end

    -- Format as relative path
    local relative = vim.fn.fnamemodify(path, ":.")
    
    -- Check if it's a directory
    if node.type == "directory" then
        -- For directories, we could add all files in it
        -- For now, just notify that it's a directory
        local confirm = vim.fn.confirm(
            string.format("Add directory: %s\nThis will add the directory path to OpenCode.", relative),
            "&Yes\n&Cancel",
            1
        )
        if confirm ~= 1 then
            return
        end
    end

    -- Add to OpenCode
    local prompt = "@" .. relative .. ": "
    require("opencode").ask(prompt, { submit = false })
    
    vim.notify(string.format("Added %s to OpenCode", relative), vim.log.levels.INFO)
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
