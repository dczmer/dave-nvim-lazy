-- ==================================================================
-- WIKI TAG AUTOCOMPLETE SOURCE FOR NVIM-CMP
-- ==================================================================

local M = {}

-- Wiki root directory
local WIKI_ROOT = vim.fn.expand("~/vimwiki")

-- Cache for tags
local tag_cache = {
    tags = nil,
    timestamp = nil,
    ttl = 600, -- 10 minutes
}

-- ==================================================================
-- TAG EXTRACTION
-- ==================================================================

-- Execute ripgrep and return lines
local function ripgrep(args)
    local cmd = "rg " .. table.concat(args, " ")
    local handle = io.popen(cmd)
    if not handle then return {} end

    local result = {}
    for line in handle:lines() do
        table.insert(result, line)
    end
    handle:close()

    return result
end

-- Extract all tags from wiki
local function get_all_tags()
    -- Check cache
    if tag_cache.tags and tag_cache.timestamp then
        local elapsed = os.time() - tag_cache.timestamp
        if elapsed < tag_cache.ttl then
            return tag_cache.tags
        end
    end

    -- Use ripgrep to find all hashtags
    local lines = ripgrep({
        '"#[a-zA-Z0-9_-]+"',
        "--only-matching",
        "--no-filename",
        "--no-line-number",
        "--type=markdown",
        WIKI_ROOT,
    })

    -- Count occurrences
    local tag_counts = {}
    for _, line in ipairs(lines) do
        local tag = line:match("#([a-zA-Z0-9_-]+)")
        if tag then
            tag_counts[tag] = (tag_counts[tag] or 0) + 1
        end
    end

    -- Convert to sorted list
    local tags = {}
    for tag, count in pairs(tag_counts) do
        table.insert(tags, { tag = tag, count = count })
    end

    table.sort(tags, function(a, b)
        if a.count == b.count then
            return a.tag < b.tag
        end
        return a.count > b.count
    end)

    -- Update cache
    tag_cache.tags = tags
    tag_cache.timestamp = os.time()

    return tags
end

-- ==================================================================
-- CMP SOURCE IMPLEMENTATION
-- ==================================================================

local source = {}

-- Initialize source
source.new = function()
    return setmetatable({}, { __index = source })
end

-- Get source name
source.get_keyword_pattern = function()
    return [[\#[a-zA-Z0-9_-]*]]
end

-- Check if source is available
source.is_available = function()
    -- Only available in markdown files within wiki
    local bufpath = vim.api.nvim_buf_get_name(0)
    local wiki_root = vim.fn.expand(WIKI_ROOT)
    return vim.bo.filetype == "markdown" and bufpath:sub(1, #wiki_root) == wiki_root
end

-- Get completion items
source.complete = function(self, params, callback)
    local input = string.sub(params.context.cursor_before_line, params.offset)

    -- Check if we're typing a hashtag
    if not input:match("^#") then
        callback({ items = {}, isIncomplete = false })
        return
    end

    -- Get tags
    local tags = get_all_tags()

    -- Convert to cmp items
    local items = {}
    for _, tag_data in ipairs(tags) do
        table.insert(items, {
            label = "#" .. tag_data.tag,
            kind = require("cmp").lsp.CompletionItemKind.Text,
            documentation = "Used " .. tag_data.count .. " times",
            insertText = tag_data.tag, -- Insert without the # since we already have it
        })
    end

    callback({ items = items, isIncomplete = false })
end

-- ==================================================================
-- CACHE INVALIDATION
-- ==================================================================

local function invalidate_cache()
    tag_cache.tags = nil
    tag_cache.timestamp = nil
end

-- ==================================================================
-- SETUP
-- ==================================================================

local setup = function()
    -- Register source with nvim-cmp
    local cmp = require("cmp")
    cmp.register_source("wiki_tags", source.new())

    -- Add to sources in markdown files
    cmp.setup.filetype("markdown", {
        sources = cmp.config.sources({
            { name = "nvim_lsp", keyword_length = 1, priority = 1000 },
            { name = "wiki_tags", keyword_length = 1, priority = 800 },
            { name = "luasnip", keyword_length = 2, priority = 750 },
            { name = "buffer", keyword_length = 3, priority = 500 },
            { name = "path", priority = 250 },
        }),
    })

    -- Invalidate cache on file save in wiki
    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = WIKI_ROOT .. "/*.md",
        callback = invalidate_cache,
    })

    -- Manual cache refresh command
    vim.api.nvim_create_user_command("WikiRefreshTags", function()
        invalidate_cache()
        print("Wiki tag cache cleared")
    end, {})
end

-- ==================================================================
-- LAZY.NVIM INTEGRATION
-- ==================================================================

return {
    lazy = function()
        return {
            "dave-vim.plugins.wiki-cmp",
            after = setup,
            -- TODO: this is a convention from lazy.nvim; lz.n doesn't support this.
            -- maybe merge with cmp-nvim or even merge all three/four together
            --after = "cmp-nvim", -- Load after nvim-cmp
            --event = "VeryLazy",
            ft = { "markdown" },
        }
    end,
}
