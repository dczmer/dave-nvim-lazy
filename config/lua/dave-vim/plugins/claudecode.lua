local setup = function()
    require("claudecode").setup({
        -- Server Configuration
        auto_start = true,
        log_level = "info", -- "trace", "debug", "info", "warn", "error"

        -- Send/Focus Behavior
        -- When true, successful sends will focus the Claude terminal if already connected
        focus_after_send = true,

        -- Selection Tracking
        track_selection = true,
        visual_demotion_delay_ms = 50,

        -- Terminal Configuration
        terminal = {
            -- NOTE: Provider set to "none" for manual tmux workflow
            -- User manages Claude session in tmux manually rather than having Neovim control terminals
            provider = "none", -- "auto", "snacks", "native", "external", "none", or custom provider table
        },

        -- Diff Integration
        diff_opts = {
            auto_close_on_accept = true,
            vertical_split = true,
            open_in_current_tab = true,
            keep_terminal_focus = false, -- If true, moves focus back to terminal after diff opens (including floating terminals)
        },
    })
end

local keys = {
    -- Group header
    { "<leader>a", nil, desc = "AI/Claude Code" },

    -- Session management
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },

    -- Model selection
    -- Use <leader>am for interactive selection, or quick-switch with <leader>a1/a2/a3
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model (interactive)" },
    { "<leader>a1", "<cmd>ClaudeCodeSelectModel sonnet-4-5<cr>", desc = "Switch to Sonnet 4.5" },
    { "<leader>a2", "<cmd>ClaudeCodeSelectModel opus-4-5<cr>", desc = "Switch to Opus 4.5" },
    { "<leader>a3", "<cmd>ClaudeCodeSelectModel haiku-4-5<cr>", desc = "Switch to Haiku 4.5" },

    -- Context/buffer operations
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
    {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file from tree",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    },

    -- Diff operations
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
}

local lazy = function()
    return {
        "claudecode.nvim",
        after = setup,
        keys = keys,
        lazy = false,
    }
end

return {
    lazy = lazy,
}
