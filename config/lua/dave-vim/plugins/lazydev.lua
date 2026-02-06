local ft = "lua"

local setup = function()
    require("lazydev").setup({
        library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "luvit-meta/library", words = { "vim%.uv" } },
        },
    })
end

return {
    lazy = function()
        return {
            "lazydev.nvim",
            ft = ft,
            after = setup,
        }
    end,
}
