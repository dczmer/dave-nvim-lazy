-- 1. base configuration
require("dave-vim.settings")
require("dave-vim.maps")
require("dave-vim.commands")
require("dave-vim.toggle-transparent-bg")

-- 2. non-lazy-loaded plugin configs go here (always sourced at startup)
-- nvim-treesitter seems to work with lazy loading but gives checkhealth errors.
require("dave-vim.plugins.nvim-treesitter")
require("dave-vim.plugins.camelcasemotion")
require("dave-vim.plugins.cmp-nvim")

-- 3. lazy and lazy configs and tweaks go last
require("dave-vim.lz-n")


vim.cmd([[
if filereadable(expand("~/.config/nvim/init.lua"))
    luafile ~/.config/nvim/init.lua
end
]])
