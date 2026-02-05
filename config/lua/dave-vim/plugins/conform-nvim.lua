local js_formatter = nil
if vim.fn.executable("deno") == 1 then
    js_formatter = "deno_fmt"
else
    js_formatter = "prettierd"
end

local setup = function()
    local conform = require("conform")
    local formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        nix = { "nixfmt" },

        --
        --
        -- JAVASCRIPT/TYPESCRIPT
        --
        javascript = { js_formatter },
        javascriptreact = { js_formatter },
        typescript = { js_formatter },
        typescriptreact = { js_formatter },
        json = { js_formatter },

        c = { "clang-format" },
        cpp = { "clang-format" },
        yaml = { "yamlfix" },
        go = { "gofmt" },
        css = { "prettier" },
        html = { "prettier" },
        --markdown = { "prettier" },
        elixir = { "mix" },
    }

    conform.setup({
        formatters = {
            stylua = {
                prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
            },
        },
        formatters_by_ft = formatters_by_ft,
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
