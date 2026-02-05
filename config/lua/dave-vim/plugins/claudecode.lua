local setup = function()
    require("claudecode").setup({
        -- Server Configuration
        --port_range = { min = 10000, max = 65535 },
        auto_start = true,
        log_level = "info", -- "trace", "debug", "info", "warn", "error"
        --terminal_cmd = nil, -- Custom terminal command (default: "claude")
        -- For local installations: "~/.claude/local/claude"
        -- For native binary: use output from 'which claude'

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
            --split_side = "left", -- "left" or "right"
            --split_width_percentage = 0.30,
            --auto_close = true,
            --snacks_win_opts = {
            --    position = "left",
            --    width = 0.3,
            --    height = 1,
            --    keys = {
            --        claude_hide = {
            --            "<C-,>",
            --            function(self)
            --                self:hide()
            --            end,
            --            mode = "t",
            --            desc = "Hide",
            --        },
            --    },
            --},

            ---- Provider-specific options (kept for reference if switching from tmux workflow)
            --provider_opts = {
            --    -- Command for external terminal provider. Can be:
            --    -- 1. String with %s placeholder: "alacritty -e %s" (backward compatible)
            --    -- 2. String with two %s placeholders: "alacritty --working-directory %s -e %s" (cwd, command)
            --    -- 3. Function returning command: function(cmd, env) return "alacritty -e " .. cmd end
            --    external_terminal_cmd = nil,
            --},
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
    }
end

return {
    lazy = lazy,
}
