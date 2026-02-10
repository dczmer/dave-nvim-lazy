local before = function()
    vim.cmd([[
        let g:wiki_root = "~/vimwiki"
    ]])
end

return {
    lazy = function()
        return {
            "wiki.vim",
            before = before,
            --ft = { "markdown", "vimwiki" },
        }
    end
}
