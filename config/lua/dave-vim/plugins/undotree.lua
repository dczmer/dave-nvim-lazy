local setup = function()
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
end

return {
    lazy = function()
        return {
            "undotree",
            after = setup,
        }
    end
}
