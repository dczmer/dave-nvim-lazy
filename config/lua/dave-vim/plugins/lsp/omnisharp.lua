-- WIP: this one never seems to load...
-- docs say you have to supply `cmd` and it has to be an absolute path.
-- that's kind of hard, since i was planning on installing the lsp
-- server with the devshells, not with nvim.

vim.lsp.config("omnisharp", {
    cmd = { "OmniSharp" },
})
vim.lsp.enable("omnisharp")
