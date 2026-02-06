local cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
}

local keys = {
    { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    --{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
}

return {
    lazy = function()
        return {
            "vim-tmux-navigator",
            cmd = cmd,
            keys = keys,
        }
    end,
}
