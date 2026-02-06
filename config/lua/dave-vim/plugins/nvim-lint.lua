local node_runtime = nil
if vim.fn.executable("node") == 1 then
    node_runtime = "node"
end

-- NOTE: seems to be ok to just define default linters for every flavor here.
-- if they don't exist it just doesn't do anything.
local linters_by_ft = {
    python = { "flake8" },
    -- lua-ls does everything we don't need an additional linter
    --lua = { 'luacheck' },
    sh = { "shellcheck" },
    bash = { "shellcheck" },
    zsh = { "shellcheck" },
    nix = { "nix" },
    yaml = { "yamllint" },
}

-- Node linters.
-- Deno lsp already takes care of linting.
if node_runtime == "node" then
    linters_by_ft["javascript"] = { "eslint" }
    linters_by_ft["javascriptreact"] = { "eslint" }
    linters_by_ft["typescript"] = { "eslint" }
    linters_by_ft["typescriptreact"] = { "eslint" }
end

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

return {
    lazy = function()
        return {
            "nvim-lint",
            after = setup,
            event = event,
        }
    end,
}
