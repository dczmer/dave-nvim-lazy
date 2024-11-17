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
            javascript = { "prettierd" },
            javascriptreact = { "prettierd" },
            typescript = { "prettierd" },
            typescriptreact = { "prettierd" },
            json = { "prettierd" },
            c = { "clang-format" },
            cpp = { "clang-format" },
            yaml = { "yamlfix" },
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
