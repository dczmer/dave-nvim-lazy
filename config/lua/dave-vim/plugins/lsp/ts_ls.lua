-- you need to setup a yarn environment and `yarn add typescript typescript-language-server`
local lspconfig = require("lspconfig")
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.ts_ls.setup({
    cmd = { 'yarn', 'run', 'typescript-language-server', '--stdio' },
    capabilities = lsp_capabilities,
})
