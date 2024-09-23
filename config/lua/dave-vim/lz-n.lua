require("lz.n").load({
    { "vim-startuptime" },
    require("dave-vim.plugins.neo-tree").lazy(),
    require("dave-vim.plugins.rainbow-delimiters").lazy(),
    require("dave-vim.plugins.telescope").lazy(),
    require("dave-vim.plugins.nvim-surround").lazy(),
    require("dave-vim.plugins.tmux-navigator").lazy(),
    { "vim-fugitive" },
    require("dave-vim.plugins.lualine").lazy(),
    require("dave-vim.plugins.bufferline").lazy(),
    require("dave-vim.plugins.lazydev").lazy(),
    { "luvit-meta" },
    require("dave-vim.plugins.cmp-nvim").lazy(),
    require("dave-vim.plugins.nvim-lint").lazy(),
    require("dave-vim.plugins.conform-nvim").lazy(),
    require("dave-vim.plugins.vim-suda").lazy(),
    {
        "vim-markdown",
        ft = "markdown",
    },
    {
        "dave-vim.plugins.lsp.lua-ls",
        load = function()
            require("dave-vim.plugins.lsp.lua-ls")
        end,
        ft = "lua",
    },
    {
        "dave-vim.plugins.lsp.nixd",
        load = function()
            require("dave-vim.plugins.lsp.nixd")
        end,
        ft = "nix",
    },
    {
        "dave-vim.plugins.lsp.pyright",
        load = function()
            require("dave-vim.plugins.lsp.pyright")
        end,
        ft = "python",
    },
})
