local setup = function()
    require('gitsigns').setup()
    vim.keymap.set(
        "n", "<leader>gb",
        "<cmd>Gitsigns toggle_current_line_blame<cr>"
    )
end

return {
    lazy = function()
        return {
            "gitsigns.nvim",
            after = setup,
        }
    end,
}
