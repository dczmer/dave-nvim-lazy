local setup = function()
    require('gitsigns').setup()
    vim.keymap.set(
        "n", "<localleader>gb",
        "<cmd>Gitsigns toggle_current_line_blame<cr>"
    )
end

local lazy = function()
    return {
        "gitsigns.nvim",
        after = setup,
    }
end

return {
    lazy = lazy,
}
