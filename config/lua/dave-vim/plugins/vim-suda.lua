local cmd = {
    "SudaRead",
    "SudaWrite",
}

local keys = {
    { "w!!", "<CMD>SudaWrite<CR>", mode = "c", desc = "SudaWrite" },
}

local lazy = function()
    return {
        "vim-suda",
        cmd = cmd,
        keys = keys,
    }
end

return {
    lazy = lazy,
}
