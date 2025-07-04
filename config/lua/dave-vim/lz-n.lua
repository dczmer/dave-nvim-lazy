require("lz.n").load({
    { "vim-startuptime" },
    require("dave-vim.plugins.neo-tree").lazy(),
    require("dave-vim.plugins.rainbow-delimiters").lazy(),
    require("dave-vim.plugins.telescope").lazy(),
    require("dave-vim.plugins.nvim-surround").lazy(),
    require("dave-vim.plugins.tmux-navigator").lazy(),
    { "vim-fugitive" },
    require("dave-vim.plugins.gitsigns").lazy(),
    require("dave-vim.plugins.lualine").lazy(),
    require("dave-vim.plugins.bufferline").lazy(),
    require("dave-vim.plugins.lazydev").lazy(),
    { "luvit-meta" },
    require("dave-vim.plugins.nvim-lint").lazy(),
    require("dave-vim.plugins.conform-nvim").lazy(),
    require("dave-vim.plugins.vim-suda").lazy(),
    require("dave-vim.plugins.nvim-dap").lazy(),
    require("dave-vim.plugins.nvim-colorizer-lua").lazy(),
    require("dave-vim.plugins.undotree").lazy(),
    require("dave-vim.plugins.tagbar").lazy(),
    {
        "vim-markdown",
        ft = { "markdown", "vimwiki" },
    },
    {
        "markdown-preview.nvim",
        ft = { "markdown", "vimwiki" },
    },
    --
    --
    -- LSP CONFIGS:
    --
    --
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
    {
        "dave-vim.plugins.lsp.gopls",
        load = function()
            require("dave-vim.plugins.lsp.gopls")
        end,
        ft = { "go", "gomod" },
    },
    {
        "dave-vim.plugins.lsp.ccls",
        load = function()
            require("dave-vim.plugins.lsp.ccls")
        end,
        ft = { "c", "cpp", "objc", "objcpp", "cuda" },
    },
    {
        "dave-vim.plugins.lsp.omnisharp",
        load = function()
            require("dave-vim.plugins.lsp.omnisharp")
        end,
        ft = "cs",
    },

    --
    --
    -- JAVASCRIPT/TYPESCRIPT LSP
    --
    -- NODE :(
    {
        "dave-vim.plugins.lsp.ts_ls",
        load = function()
            require("dave-vim.plugins.lsp.ts_ls")
        end,
        ft = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
        },
    },
    --
    -- DENO :)
    --{
    --    "dave-vim.plugins.lsp.denols",
    --    load = function()
    --        require("dave-vim.plugins.lsp.denols")
    --    end,
    --    ft = {
    --        "javascript",
    --        "javascriptreact",
    --        "javascript.jsx",
    --        "typescript",
    --        "typescriptreact",
    --        "typescript.tsx",
    --    },
    --},
    --
    --
})
