-- the highlighting is very nice; try `TSDisable highlight` to see without.
-- folding works well also, and doesn't require language-specific plugins.
require("nvim-treesitter").setup({
    sync_install = false,
    auto_install = false,
    highlight = {
        enable = true,
        -- disable = table/function
        additional_vim_regex_highlighting = true,
    },
    indent = { enable = true },
})
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
