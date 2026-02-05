local builtin = require("telescope.builtin")

-- ==================================================================
-- SETUP FUNCTION
-- ==================================================================
local setup = function()
    require("telescope").setup({
        defaults = {
            -- Performance: File ignores
            file_ignore_patterns = {
                "^%.git/",
                "node_modules/",
                "__pycache__/",
                "%.o",
                "%.a",
                "%.out",
                "%.pdf",
                "%.mkv",
                "%.mp4",
                "result/", -- Nix-specific
                ".direnv/", -- Nix-specific
            },

            -- Layout: Horizontal with good preview
            layout_strategy = "horizontal",
            layout_config = {
                horizontal = {
                    prompt_position = "top",
                    preview_width = 0.55,
                    results_width = 0.8,
                },
                width = 0.87,
                height = 0.80,
                preview_cutoff = 120,
            },

            -- Sorting: Ascending with prompt at top
            sorting_strategy = "ascending",

            -- UI elements
            prompt_prefix = "  ",
            selection_caret = " ",
            entry_prefix = "  ",

            -- Performance
            path_display = { "truncate" },

            -- Keybindings in picker
            mappings = {
                i = {
                    ["<C-n>"] = "move_selection_next",
                    ["<C-p>"] = "move_selection_previous",
                    ["<C-j>"] = "move_selection_next",
                    ["<C-k>"] = "move_selection_previous",
                    ["<C-c>"] = "close",
                    ["<Esc>"] = "close",
                    ["<CR>"] = "select_default",
                    ["<C-x>"] = "select_horizontal",
                    ["<C-v>"] = "select_vertical",
                    ["<C-t>"] = "select_tab",
                    ["<C-u>"] = "preview_scrolling_up",
                    ["<C-d>"] = "preview_scrolling_down",
                    --["<C-q>"] = "send_to_qflist + open_qflist",
                    --["<M-q>"] = "send_selected_to_qflist + open_qflist",
                    --["<Tab>"] = "toggle_selection + move_selection_worse",
                    --["<S-Tab>"] = "toggle_selection + move_selection_better",
                    ["<C-/>"] = "which_key",
                },
                n = {
                    ["<Esc>"] = "close",
                    ["<CR>"] = "select_default",
                    ["<C-x>"] = "select_horizontal",
                    ["<C-v>"] = "select_vertical",
                    ["<C-t>"] = "select_tab",
                    ["j"] = "move_selection_next",
                    ["k"] = "move_selection_previous",
                    ["gg"] = "move_to_top",
                    ["G"] = "move_to_bottom",
                    ["<C-u>"] = "preview_scrolling_up",
                    ["<C-d>"] = "preview_scrolling_down",
                    ["?"] = "which_key",
                },
            },
        },

        pickers = {
            find_files = {
                theme = "dropdown",
                find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
            },
            live_grep = {
                additional_args = function()
                    return { "--hidden" }
                end,
            },
            buffers = {
                theme = "dropdown",
                initial_mode = "normal",
                mappings = {
                    i = { ["<C-d>"] = "delete_buffer" },
                    n = { ["dd"] = "delete_buffer" },
                },
            },
            help_tags = { theme = "ivy" },
            oldfiles = { theme = "dropdown" },
            lsp_references = { theme = "dropdown", initial_mode = "normal" },
            lsp_definitions = { theme = "dropdown", initial_mode = "normal" },
            lsp_implementations = { theme = "dropdown", initial_mode = "normal" },
            diagnostics = { theme = "ivy", initial_mode = "normal" },
            git_files = { theme = "dropdown", show_untracked = true },
            git_commits = { theme = "ivy" },
            git_status = { theme = "dropdown", initial_mode = "normal" },
        },

        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            },
        },
    })

    -- CRITICAL: Load FZF extension for 20-50x performance boost
    require("telescope").load_extension("fzf")

    -- ==================================================================
    -- THEME CONSISTENCY
    -- ==================================================================
    -- Match existing float window theme (#333333 background)
    local set_hl_for_telescope = function()
        local set_hl = vim.api.nvim_set_hl
        set_hl(0, "TelescopeNormal", { link = "NormalFloat" })
        set_hl(0, "TelescopeBorder", { link = "FloatBorder" })
        set_hl(0, "TelescopePromptNormal", { link = "NormalFloat" })
        set_hl(0, "TelescopePromptBorder", { link = "FloatBorder" })
        set_hl(0, "TelescopeResultsNormal", { link = "NormalFloat" })
        set_hl(0, "TelescopeResultsBorder", { link = "FloatBorder" })
        set_hl(0, "TelescopePreviewNormal", { link = "NormalFloat" })
        set_hl(0, "TelescopePreviewBorder", { link = "FloatBorder" })
    end
    set_hl_for_telescope()

    -- Persist after colorscheme changes (follows settings.lua pattern)
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        desc = "Re-apply telescope colors after colorscheme change",
        callback = set_hl_for_telescope,
    })
end

-- ==================================================================
-- KEYBINDINGS
-- ==================================================================
local keys = {
    -- ==================================================================
    -- FILE NAVIGATION
    -- ==================================================================
    { "<leader>ff", builtin.find_files, desc = "Find files" },
    {
        "<leader>fF",
        function()
            builtin.find_files({ hidden = true, no_ignore = true })
        end,
        desc = "Find ALL files (hidden/ignored)",
    },
    { "<leader>fr", builtin.oldfiles, desc = "Recent files" },
    { "<leader>fw", builtin.grep_string, desc = "Find word under cursor" },

    -- ==================================================================
    -- TEXT SEARCH
    -- ==================================================================
    { "<leader>fg", builtin.live_grep, desc = "Live grep" },
    {
        "<leader>fG",
        function()
            builtin.live_grep({ additional_args = { "--no-ignore" } })
        end,
        desc = "Live grep (all files)",
    },

    { "<leader>fs", builtin.current_buffer_fuzzy_find, desc = "Search current buffer" },

    -- ==================================================================
    -- BUFFER MANAGEMENT
    -- ==================================================================
    { "<leader>fb", builtin.buffers, desc = "Buffers" },

    -- ==================================================================
    -- LSP INTEGRATION
    -- ==================================================================
    {
        "<leader>fl",
        function()
            builtin.lsp_references({ include_declaration = false })
        end,
        desc = "LSP: Find references",
    },
    { "<leader>fd", builtin.lsp_definitions, desc = "LSP: Definitions" },
    { "<leader>fD", builtin.lsp_type_definitions, desc = "LSP: Type definitions" },
    { "<leader>fi", builtin.lsp_implementations, desc = "LSP: Implementations" },
    { "<leader>fx", builtin.diagnostics, desc = "LSP: Diagnostics (all)" },
    {
        "<leader>fX",
        function()
            builtin.diagnostics({ bufnr = 0 })
        end,
        desc = "LSP: Diagnostics (current)",
    },
    { "<leader>fo", builtin.lsp_document_symbols, desc = "LSP: Document symbols" },
    { "<leader>fO", builtin.lsp_workspace_symbols, desc = "LSP: Workspace symbols" },

    -- ==================================================================
    -- GIT INTEGRATION
    -- ==================================================================
    { "<leader>fc", builtin.git_commits, desc = "Git commits" },
    { "<leader>fC", builtin.git_bcommits, desc = "Git buffer commits" },
    { "<leader>ft", builtin.git_status, desc = "Git status" },
    { "<leader>fB", builtin.git_branches, desc = "Git branches" },
    { "<leader>fT", builtin.git_files, desc = "Git tracked files" },

    -- ==================================================================
    -- VIM INTERNALS
    -- ==================================================================
    { "<leader>fh", builtin.help_tags, desc = "Help tags" },
    { "<leader>fk", builtin.keymaps, desc = "Keymaps" },
    { "<leader>fm", builtin.marks, desc = "Marks" },
    { "<leader>fj", builtin.jumplist, desc = "Jump list" },
    { "<leader>fq", builtin.quickfix, desc = "Quickfix list" },
    { "<leader>fL", builtin.loclist, desc = "Location list" },
    { "<leader>fv", builtin.vim_options, desc = "Vim options" },
    { "<leader>f:", builtin.command_history, desc = "Command history" },
    { "<leader>f/", builtin.search_history, desc = "Search history" },
    { "<leader>fR", builtin.registers, desc = "Registers" },
    { "<leader>fA", builtin.autocommands, desc = "Autocommands" },
    { "<leader>fH", builtin.highlights, desc = "Highlight groups" },
    { "<leader>fz", builtin.spell_suggest, desc = "Spelling suggestions" },

    -- ==================================================================
    -- TELESCOPE META
    -- ==================================================================
    { "<leader>f?", builtin.builtin, desc = "Telescope pickers" },
    { "<leader>fp", builtin.resume, desc = "Resume previous picker" },
}

-- ==================================================================
-- LAZY LOADER
-- ==================================================================
local lazy = function()
    return {
        "telescope.nvim",
        keys = keys,
        after = setup,
    }
end

return {
    lazy = lazy,
}
