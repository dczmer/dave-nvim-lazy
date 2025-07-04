local setup = function()
    vim.keymap.set('n', '<localleader>u', vim.cmd.UndotreeToggle)
end

return {
    lazy = function()
        return {
            "undotree",
            after = setup,
        }
    end
}
