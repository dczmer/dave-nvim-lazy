local setup = function()
    vim.g.opencode_opts = {
        port = 6999,
        provider = {
            enabled = "tmux",
        },
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true
end

local keys = {
    { "<leader>a", nil, desc = "AI/OpenCode" },
    {
        "<leader>as",
        function()
            require("opencode").ask("@this: ", { submit = true })
        end,
        { desc = "Ask OpenCode" },
    },
    {
        "<leader>ax",
        function()
            require("opencode").select()
        end,
        { desc = "Select operation" },
    },
    {
        "<leader>ao",
        function()
            return require("opencode").operator("@this ")
        end,
        { desc = "Add range to OpenCode", expr = true },
    },
    {
        "<leader>aoo",
        function()
            return require("opencode").operator("@this ") .. "_"
        end,
        { desc = "Add line to OpenCode", expr = true },
    },
    {
        "<leader>ak",
        function()
            require("opencode").command("session.half.page.up")
        end,
        { desc = "Scroll OpenCode up" },
    },
    {
        "<leader>aj",
        function()
            require("opencode").command("session.half.page.down")
        end,
        { desc = "Scroll OpenCode down" },
    },
}

return {
    lazy = function()
        return {
            "opencode.nvim",
            after = setup,
            keys = keys,
        }
    end,
}
