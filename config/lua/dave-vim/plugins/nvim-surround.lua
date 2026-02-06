local opts = {}

local setup = function()
    require("nvim-surround").setup(opts)
end

return {
    lazy = function()
        return {
            "nvim-surround",
            after = setup,
        }
    end,
}
