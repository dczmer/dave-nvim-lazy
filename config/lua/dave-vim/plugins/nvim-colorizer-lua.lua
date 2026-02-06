local setup = function()
    require("colorizer").setup({
        '*';
    })
end

return {
    lazy = function()
        return {
            "nvim-colorizer.lua",
            after = setup,
        }
    end,
}
