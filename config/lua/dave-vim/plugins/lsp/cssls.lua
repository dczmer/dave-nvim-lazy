vim.lsp.config("cssls", {
    filetypes = { "css", "scss", "less" },
    init_options = { providerFormatter = true },
    settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
    },
})
vim.lsp.enable("cssls")
