local lspconfig = require("lspconfig")
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
local util = require("lspconfig.util")

local root_files = {
    "pyrightconfig.json",
}

lspconfig.pyright.setup({
    cmd = { "pyright-langserver", "--stdio" },
    capabilities = lsp_capabilities,
    root_dir = function(fname)
        return (
            util.root_pattern(unpack(root_files))(fname)
            or util.find_git_ancestor(fname)
            or util.path.dirname(fname)
        )
    end,
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
            }
        }
    }
})
