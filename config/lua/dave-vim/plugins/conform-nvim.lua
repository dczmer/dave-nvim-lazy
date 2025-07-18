local setup = function()
    local conform = require("conform")
    conform.setup({
        formatters = {
            stylua = {
                prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
            },
        },
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "isort", "black" },
            nix = { "nixfmt" },

            --
            --
            -- JAVASCRIPT/TYPESCRIPT
            --
            -- NODE :(
            javascript = { "prettierd" },
            javascriptreact = { "prettierd" },
            typescript = { "prettierd" },
            typescriptreact = { "prettierd" },
            json = { "prettierd" },
            --
            -- DENO :)
            --javascript = { "deno_fmt" },
            --javascriptreact = { "deno_fmt" },
            --typescript = { "deno_fmt" },
            --typescriptreact = { "deno_fmt" },
            --json = { "deno_fmt" },
            --
            --

            c = { "clang-format" },
            cpp = { "clang-format" },
            yaml = { "yamlfix" },
            go = { "gofmt" },
            css = { "prettier" },
            html = { "prettier" },
            markdown = { "prettier" },
        },
        format_on_save = {
            lsp_format = "fallback",
            timeout_ms = 500,
        },
    })
end

local keys = {
    {
        "<localleader>fw",
        function()
            require("conform").format({
                bufnr = vim.api.nvim_get_current_buf(),
            })
        end,
    },
}

local lazy = function()
    return {
        "conform.nvim",
        after = setup,
        keys = keys,
    }
end

return {
    lazy = lazy,
}
