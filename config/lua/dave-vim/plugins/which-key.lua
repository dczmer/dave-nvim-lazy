local keys = {
    {
        "<leader>?",
        function()
            require("which-key").show()
        end,
        desc = "Which-Key toggle",
    },
}

local setup = function()
    require("which-key").setup({
        triggers = {},
    })
end

local lazy = function()
    return {
        "which-key.nvim",
        keys = keys,
        after = setup,
        lazy = false,
    }
end

return {
    lazy = lazy,
}
