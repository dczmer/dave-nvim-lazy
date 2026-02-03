local setup = function()
    require("snacks").setup({
        animate = { enabled = false },
        -- TODO: configure `bigfile`
        -- >> bigfile adds a new filetype bigfile to Neovim that triggers when the file is larger than the configured size. This automatically prevents things like LSP and Treesitter attaching to the buffer.
        bigfile = { enabled = true },
        bufdelete = { enabled = false },
        dashboard = { enabled = false },
        dim = { enabled = true },
        -- i use neotree
        explorer = { enabled = false },
        gh = { enabled = false },
        -- i use fugitive
        git = { enabled = false },
        gitbrowse = { enabled = false },
        -- i do use kitty, so i can use `image`
        image = { enabled = true },
        -- TODO: i like `indent`, but it's too loud. can i toggle it on/off?
        indent = { enabled = true },
        input = { enabled = true },
        layout = { enabled = false },
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
        zen = { enabled = true },
    })
end

local lazy = function()
    return {
        "snacks.nvim",
        after = setup,
        lazy = false,
    }
end

return {
    lazy = lazy,
}
