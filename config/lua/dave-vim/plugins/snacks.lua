local setup = function()
    require("snacks").setup({
        animate = { enabled = false },
        bigfile = { enabled = true },
        bufdelete = { enabled = false },
        dashboard = { enabled = false },
        dim = { enabled = true },
        -- i use neotree
        explorer = { enabled = true },
        gh = { enabled = false },
        -- i use fugitive
        git = { enabled = false },
        gitbrowse = { enabled = false },
        -- i do use kitty, so i can use `image`
        image = { enabled = true },
        -- TODO: i like `indent`, but it's too loud. can i toggle it on/off?
        indent = { enabled = false },
        input = { enabled = true },
        layout = { enabled = true },
        lazygit = { enabled = false },
        notifier = { enabled = true },
        notify = { enabled = true },
        picker = { enabled = true },
        -- `profiler` might be useful later
        profiler = { enabled = false },
        quickfile = { enabled = true },
        rename = { enabled = false },
        scope = { enabled = true },
        scratch = { enabled = false },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        terminal = { enabled = true },
        toggle = { enable = true },
        win = { enable = true },
        words = { enabled = true },
        zen = {
            -- You can add any `Snacks.toggle` id here.
            -- Toggle state is restored when the window is closed.
            -- Toggle config options are NOT merged.
            toggles = {
                dim = true,
                git_signs = false,
                mini_diff_signs = false,
                -- diagnostics = false,
                -- inlay_hints = false,
            },
            center = true, -- center the window
            show = {
                statusline = false, -- can only be shown when using the global statusline
                tabline = false,
            },
            win = { style = "zen" },
            --- Callback when the window is opened.
            --on_open = function(win) end,
            --- Callback when the window is closed.
            --on_close = function(win) end,
            --- Options for the `Snacks.zen.zoom()`
            zoom = {
                toggles = {},
                center = false,
                show = { statusline = true, tabline = true },
                win = {
                    backdrop = false,
                    width = 0, -- full width
                },
            },
        },
    })
end

local keys = {
    {
        "<leader>zz",
        function()
            Snacks.zen()
        end,
        desc = "Toggle Zen Mode",
    },
}

return {
    lazy = function()
        return {
            "snacks.nvim",
            after = setup,
            keys = keys,
            lazy = false,
        }
    end,
}
