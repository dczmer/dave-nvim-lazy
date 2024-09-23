local opts = {}

local setup = function()
    require("nvim-surround").setup(opts)
end

local lazy = function()
    return {
        "nvim-surround",
        after = setup,
    }
end

return {
    lazy = lazy,
}
