local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("pyright", {
    cmd = { "pyright-langserver", "--stdio" },
    capabilities = lsp_capabilities,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = false,
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "basic",
                exclude = {
                    "**/node_modules",
                    "**/__pycache__",
                },
                userFileIndexingLimit = 4000,
            },
        },
    },
})
vim.lsp.enable("pyright")
