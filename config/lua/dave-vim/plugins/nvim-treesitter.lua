-- the highlighting is very nice; try `TSDisable highlight` to see without.
-- folding works well also, and doesn't require language-specific plugins.
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
