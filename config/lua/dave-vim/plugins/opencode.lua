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
            })
        end
    end)
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
