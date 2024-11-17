-- NOTE: seems to be ok to just define default linters for every flavor here.
-- if they don't exist it just doesn't do anything.
local linters_by_ft = {
    python = { "flake8" },
    -- lua-ls does everything we don't need an additional linter
    --lua = { 'luacheck' },
    bash = { "shellcheck" },
    zsh = { "shellcheck" },
    nix = { "nix" },
    javascript = { "eslint" },
    javascriptreact = { "eslint" },
    typescript = { "eslint" },
    typescriptreact = { "eslint" },
    yaml = { "yamllint" },
}

local event = "BufWritePost"

local setup = function()
    local lint = require("lint")
    lint.linters_by_ft = linters_by_ft
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
            lint.try_lint()
        end,
    })
end

local lazy = function()
    return {
        "nvim-lint",
        after = setup,
        event = event,
    }
end

return {
    lazy = lazy,
}
