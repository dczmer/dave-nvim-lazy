local M = {}

M.transparent_bg = {
    "Normal",
    "ctermfg=188",
    "ctermbg=NONE",
    "guifg=#e8e8d3",
    "guibg=NONE",
}

M.opaque_bg = {
    "Normal",
    "ctermfg=188",
    "ctermbg=234",
    "guifg=#e8e8d3",
    "guibg=#151515",
}

M.is_transparent = 0

M.Toggle_transparent_bg = function()
    if M.is_transparent > 0 then
        vim.cmd.highlight(M.opaque_bg)
        M.is_transparent = 0
    else
        vim.cmd.highlight(M.transparent_bg)
        M.is_transparent = 1
    end
end

vim.api.nvim_create_user_command("ToggleTransparentBG", M.Toggle_transparent_bg, {})

vim.keymap.set("n", ",bg", M.Toggle_transparent_bg)

return M
