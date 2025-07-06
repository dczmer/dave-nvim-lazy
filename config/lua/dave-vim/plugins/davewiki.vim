" Find 'tags' by file name with fzf+rg, insert a vimwiki link.
" I would like to try to port this to lua but i was having trouble with the
" fzf function calls.

" NOTE: this was really hard to translate to nvim lua, because of the number
" of nested calls of `vim.api.nvim_function_call` and issues with bridging the
" lua code with this particular vimscript-based plugin.

if (!exists("g:davewiki_tag_search_command"))
    let g:davewiki_tag_search_command = "rg --column --line-number --ignore-case --no-heading --type=markdown --glob=!diary/ --files ."
endif

if (!exists("g:davewiki_fzf_options"))
    let g:davewiki_fzf_options = "--style=full --preview='bat --color=always {}' --preview-window=right --border --layout=reverse --info=inline"
endif

function! s:WriteTag(item)
    " grep for first heading of file and use as link title
    let match = system("grep -E '^# .+' " ..
        \ shellescape(a:item) .. 
        \ " | head -n1 | cut -d' ' -f2- | tr -d '\n'"
        \)
    let title = match
    let text = printf("[%s](%s)", title, a:item)
    exe "normal! a" . text . "\<esc>"
endfunction

function! g:DavewikiTagSearch()
    call fzf#run(
        \ fzf#wrap({
        \ 'source': g:davewiki_tag_search_command,
        \ 'sink': { item -> s:WriteTag(item) },
        \ 'options': g:davewiki_fzf_options,
        \}))
endfunction

let g:davewiki_backlink_search_command = "rg -e '%s' --column --no-heading --files ."

command! -nargs=0 DavewikiTagSearch call DavewikiTagSearch()

imap <silent> [[ <esc>:call DavewikiTagSearch()<CR>
