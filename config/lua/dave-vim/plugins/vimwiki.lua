vim.cmd([[
    let g:vimwiki_list = [{
        \ 'path': '~/vimwiki/',
        \ 'syntax': 'markdown',
        \ 'ext': 'md',
    \}]
    let g:vimwiki_custom_wiki2html = 'vimwiki_markdown'
    let g:vimwiki_global_ext = 0
]])
vim.keymap.set("n", "<localleader>wj", "<CMD>VimwikiMakeDiaryNote<CR>");
