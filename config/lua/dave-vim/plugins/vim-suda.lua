local cmd = {
    "SudaRead",
    "SudaWrite",
}

local keys = {
    { "w!!", "<CMD>SudaWrite<CR>", mode = "c", desc = "SudaWrite" },
}

return {
    lazy = function()
        return {
            "vim-suda",
            cmd = cmd,
            keys = keys,
        }
    end,
}
