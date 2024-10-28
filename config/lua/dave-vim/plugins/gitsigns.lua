local setup = function()
    require('gitsigns').setup()
end

local keys = {
    {
        "<localleader>gb",
        function()
            vim.cmd("Gitsigns toggle_current_line_blame")
        end,
    },
}

local lazy = function()
    return {
        "gitsigns.nvim",
        after = setup,
        keys = keys,
    }
end

return {
    lazy = lazy,
}
