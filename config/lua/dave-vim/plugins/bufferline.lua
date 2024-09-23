local setup = function()
    local bufferline = require("bufferline")
    bufferline.setup({
        options = {
            mode = "buffers",
            style_preset = bufferline.style_preset.minimal,
            themable = true,
            numbers = "buffer_id",
        },
    })
end

local lazy = function()
    return {
        "bufferline.nvim",
        after = setup,
    }
end

return {
    lazy = lazy,
}
