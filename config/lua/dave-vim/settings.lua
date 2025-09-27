local o = vim.opt

o.compatible = false
vim.cmd("autocmd!")
o.history = 500
o.showmode = true
o.wildmode = "list:longest,full"
o.showcmd = true
o.showmatch = true
o.autowrite = true
o.completeopt = "menuone"
o.scrolloff = 6
o.backspace = "indent,eol,start"
o.ruler = true
o.nu = true
o.rnu = true
o.modeline = false
o.wrap = false
o.textwidth = 0
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.shiftround = true
o.autoindent = true
o.expandtab = true
o.incsearch = true
o.hidden = true
o.swapfile = false
o.mouse = ""
o.mousehide = true
o.encoding = "utf-8"
o.updatetime = 300
o.signcolumn = "yes"
o.spell = true

vim.cmd([[
    filetype on
    filetype indent on
    filetype plugin on
    syntax on
]])

vim.cmd.colorscheme("cyberdream")

local set_hl_for_float = function()
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#333333" })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#333333" })
end
set_hl_for_float()
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    desc = "Re-apply float window colors after changing schemes.",
    callback = set_hl_for_float,
})
