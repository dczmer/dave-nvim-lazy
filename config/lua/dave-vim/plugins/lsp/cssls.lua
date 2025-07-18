local lspconfig = require("lspconfig")

lspconfig.cssls.setup({
    filetypes = { 'css', 'scss', 'less' },
    init_options = { providerFormatter = true },
    settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
    },
});
