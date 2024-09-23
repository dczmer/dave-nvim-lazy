local builtin = require("telescope.builtin")

local keys = {
    { "<leader>ff", builtin.find_files },
    { "<leader>fg", builtin.live_grep },
    { "<leader>fb", builtin.buffers },
    { "<leader>fh", builtin.help_tags },
}

local lazy = function()
    return {
        "telescope.nvim",
        keys = keys,
    }
end

return {
    lazy = lazy,
}
