local lspconfig = require("lspconfig")

vim.lsp.config('elixirls', {
    cmd = { "elixir-ls" };
})

lspconfig.elixirls.setup({
    cmd = { "elixir-ls" };
})
