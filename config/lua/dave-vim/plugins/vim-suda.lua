
--{
--    "vim-suda",
--    cmd = {
--        "SudaRead",
--        "SudaWrite",
--    },
--    keys = {
--        { "w!!", "<CMD>SudaWrite<CR>", mode = "c", desc = "NeoTree toggle" },
--    },
--},

local cmd = {
    "SudaRead",
    "SudaWrite",
}

local keys = {
    { "w!!", "<CMD>SudaWrite<CR>", mode = "c", desc = "NeoTree toggle" },
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
