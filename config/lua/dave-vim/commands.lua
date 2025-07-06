vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = {
        "*.nix",
        "*.css",
        "*.html",
        "*.js",
        "*.ts",
        "*.jsx",
        "*.tsx",
    },
    command = "setlocal tabstop=2 | setlocal softtabstop=2 | setlocal shiftwidth=2",
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.md" },
    command = "setlocal wrap",
})
