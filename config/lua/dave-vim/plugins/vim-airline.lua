-- TODO: use lualine and bufferline for pure lua config
local before = function()
    vim.cmd([[
        let g:airline_theme = 'jellybeans'
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#show_tab_nr = 1
        let g:airline#extensions#tabline#tab_nr_type = 1
        let g:airline#extensions#tabline#fnamemod = ':t'
        let g:airline#extensions#tabline#buffer_idx_mode = 1
        let g:airline_powerline_fonts = 1
        let g:airline_section_c = '%t'
        let g:airline#extensions#default#section_truncate_width = { 'c': 40 }
    ]])
end

local lazy = function()
    return {
        "vim-airline",
        before = before,
    }
end

return {
    lazy = lazy,
}
