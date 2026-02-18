local keys = {
    { "<leader>tt", "<CMD>Neotree toggle<CR>", desc = "NeoTree toggle" },
}

local opts = {
    -- Enable git status integration
    enable_git_status = true,
    enable_diagnostics = false,

    -- Default component configs (git symbols)
    default_component_configs = {
        git_status = {
            symbols = {
                added     = "✚",
                modified  = "",
                deleted   = "✖",
                renamed   = "󰁕",
                untracked = "",
                ignored   = "",
                unstaged  = "󰄱",
                staged    = "",
                conflict  = "",
            },
        },
    },

    -- Filesystem source configuration
    filesystem = {
        filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {
                "node_modules",
                "__pycache__",
                ".git",
                ".DS_Store",
            },
            never_show = {
                ".direnv",  -- Nix direnv cache
                "result",   -- Nix build outputs
            },
        },
        follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
        },
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "open_default",
    },

    -- Git status source configuration
    git_status = {
        window = {
            position = "float",
            mappings = {
                ["A"] = "git_add_all",
                ["gu"] = "git_unstage_file",
                ["ga"] = "git_add_file",
                ["gr"] = "git_revert_file",
                ["gc"] = "git_commit",
                ["gp"] = "git_push",
            },
        },
    },

    -- Window configuration
    window = {
        position = "left",
        width = 40,
        mappings = {
            -- Navigation
            ["<space>"] = "toggle_node",
            ["<cr>"] = "open",
            ["P"] = { "toggle_preview", config = { use_float = true } },

            -- Splits
            ["s"] = "open_split",
            ["v"] = "open_vsplit",
            ["t"] = "open_tabnew",

            -- Window control
            ["C"] = "close_node",
            ["z"] = "close_all_nodes",
            ["Z"] = "expand_all_nodes",

            -- File operations
            ["a"] = { "add", config = { show_path = "relative" } },
            ["A"] = "add_directory",
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy",
            ["m"] = "move",

            -- Refresh & reveal
            ["R"] = "refresh",
            ["."] = "set_root",
            ["H"] = "toggle_hidden",
            ["/"] = "fuzzy_finder",

            -- Other
            ["q"] = "close_window",
            ["?"] = "show_help",
            ["i"] = "show_file_details",

            -- OpenCode integration (preserved from original config)
            ["<leader>aa"] = {
                function(state)
                    local node = state.tree:get_node()
                    if not node then
                        vim.notify("No node selected", vim.log.levels.WARN)
                        return
                    end

                    local path = node:get_id()
                    if not path or path == "" then
                        vim.notify("Invalid node path", vim.log.levels.WARN)
                        return
                    end

                    -- Format as relative path
                    local relative = vim.fn.fnamemodify(path, ":.")

                    -- Check if it's a directory
                    if node.type == "directory" then
                        local confirm = vim.fn.confirm(
                            string.format("Add directory: %s\nThis will add the directory path to OpenCode.", relative),
                            "&Yes\n&Cancel",
                            1
                        )
                        if confirm ~= 1 then
                            return
                        end
                    end

                    vim.notify(string.format("Added %s to OpenCode", relative), vim.log.levels.INFO)
                end,
                desc = "Add to OpenCode",
            },
        },
    },
}

local setup = function()
    require("neo-tree").setup(opts)
end

return {
    lazy = function()
        return {
            "neo-tree.nvim",
            keys = keys,
            after = setup
        }
    end,
}
