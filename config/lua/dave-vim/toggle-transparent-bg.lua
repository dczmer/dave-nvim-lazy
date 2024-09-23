local transparent = 0

local Toggle_transparent_bg = function()
    if transparent > 0 then
        vim.cmd.highlight({
            "Normal",
            "ctermfg=188",
            "ctermbg=234",
            "guifg=#e8e8d3",
            "guibg=#151515",
        })
        transparent = 0
    else
        vim.cmd.highlight({
            "Normal",
            "ctermfg=188",
            "ctermbg=NONE",
            "guifg=#e8e8d3",
            "guibg=NONE",
        })
        transparent = 1
    end
end

vim.keymap.set("n", ",bg", Toggle_transparent_bg)
