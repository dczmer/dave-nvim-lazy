local keys = {
    { "<leader>tt", "<CMD>Neotree toggle<CR>", desc = "NeoTree toggle" },
}

local opts = {
    window = {
        mappings = {
            -- Add custom mapping to send node to OpenCode
            ["<leader>aa"] = {
                function(state)
                    local node = state.tree:get_node()
                    if not node then
                        vim.notify("No node selected", vim.log.levels.WARN)
                        return
                    end

                    local path = node:get_id()
                    if not path or path == "" then
                        vim.notify("Invalid node path", vim.log.levels.WARN)
                        return
                    end

                    -- Format as relative path
                    local relative = vim.fn.fnamemodify(path, ":.")

                    -- Check if it's a directory
                    if node.type == "directory" then
                        local confirm = vim.fn.confirm(
                            string.format("Add directory: %s\nThis will add the directory path to OpenCode.", relative),
                            "&Yes\n&Cancel",
                            1
                        )
                        if confirm ~= 1 then
                            return
                        end
                    end

                    -- Add to OpenCode
                    local prompt = "@" .. relative .. ": "
                    require("opencode").ask(prompt, { submit = false })

                    vim.notify(string.format("Added %s to OpenCode", relative), vim.log.levels.INFO)
                end,
                desc = "Add to OpenCode",
            },
        },
    },
}

local setup = function()
    require("neo-tree").setup(opts)
end

local lazy = function()
    return {
        "neo-tree.nvim",
        keys = keys,
        after = setup
    }
end

return {
    lazy = lazy,
}
