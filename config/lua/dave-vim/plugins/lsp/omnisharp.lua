-- WIP: this one never seems to load...
-- docs say you have to supply `cmd` and it has to be an absolute path.
-- that's kind of hard, since i was planning on installing the lsp
-- server with the devshells, not with nvim.

local lspconfig = require("lspconfig")
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.omnisharp.setup({
    cmd = { "OmniSharp" },
    capabilities = lsp_capabilities,
})
