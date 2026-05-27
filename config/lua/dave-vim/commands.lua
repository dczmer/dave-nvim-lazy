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
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if lang and pcall(vim.treesitter.language.inspect, lang) then
            vim.treesitter.start(args.buf)
        end
    end,
})
vim.lsp.config('*', {
    root_markers = { '.git' },
})
