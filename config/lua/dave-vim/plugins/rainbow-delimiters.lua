local setup = function()
    local rainbow = require("rainbow-delimiters")
    require("rainbow-delimiters.setup").setup({
        strategy = {
            -- only highlight within the active code block
            -- if this is slow, override per language or change to 'global'
            [""] = rainbow.strategy["local"],
        },
        query = {
            [""] = "rainbow-delimiters",
            lua = "rainbow-blocks",
            query = "rainbow-blocks",
        },
        --highlight = {
        --},
    })
end

local lazy = function()
    return {
        "rainbow-delimiters.nvim",
        after = setup,
    }
end

return {
    lazy = lazy,
}
