local keys = {
    { "<leader>ft", "<CMD>Neotree toggle<CR>", desc = "NeoTree toggle" },
}

local opts = { }

local setup = function()
    require("neo-tree").setup(opts)
end

local lazy = function()
    return {
        "neo-tree.nvim",
        keys = keys,
        after = setup
    }
end

return {
    lazy = lazy,
}
