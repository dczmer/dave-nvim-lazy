local setup = function()
    require("colorizer").setup({
        '*';
    })
end

local lazy = function()
    return {
        "nvim-colorizer.lua",
        after = setup,
    }
end

return {
    lazy = lazy
}
