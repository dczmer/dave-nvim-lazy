local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")
local utils = require("telescope.utils")
local entry_display = require("telescope.pickers.entry_display")

-- ==================================================================
-- CONFIGURATION
-- ==================================================================
local M = {}

-- Wiki root directory
local WIKI_ROOT = vim.fn.expand("~/vimwiki")

-- Cache storage
local cache = {
    tags = {},
    backlinks = {},
    headings = {},
    timestamps = {},
}

-- Cache TTL in seconds
local CACHE_TTL = {
    tags = 600,     -- 10 minutes
    backlinks = 300, -- 5 minutes
}

-- ==================================================================
-- UTILITY FUNCTIONS
-- ==================================================================

-- Get relative path from wiki root
local function get_relative_path(filepath)
    local expanded = vim.fn.expand(filepath)
    local wiki_root = vim.fn.expand(WIKI_ROOT)
    if expanded:sub(1, #wiki_root) == wiki_root then
        return expanded:sub(#wiki_root + 2) -- +2 to skip trailing slash
    end
    return expanded
end

-- Get current buffer's wiki-relative path
local function get_current_wiki_path()
    return get_relative_path(vim.api.nvim_buf_get_name(0))
end

-- Check if cache is valid
local function is_cache_valid(key, ttl)
    if not cache.timestamps[key] then
        return false
    end
    local elapsed = os.time() - cache.timestamps[key]
    return elapsed < ttl
end

-- Invalidate cache
local function invalidate_cache(key)
    cache[key] = {}
    cache.timestamps[key] = nil
end

-- Extract first heading from file
local function extract_heading(filepath)
    local file = io.open(filepath, "r")
    if not file then return nil end

    for line in file:lines() do
        local heading = line:match("^#%s+(.+)")
        if heading then
            file:close()
            return heading
        end
    end

    file:close()
    return nil
end

-- Execute ripgrep command and return lines
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

-- ==================================================================
-- TAG EXTRACTION
-- ==================================================================

-- Extract all tags from wiki
local function get_all_tags()
    if is_cache_valid("tags", CACHE_TTL.tags) then
        return cache.tags
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

    cache.tags = tags
    cache.timestamps.tags = os.time()

    return tags
end

-- Extract tags from current buffer
local function get_buffer_tags()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    local tag_counts = {}
    for _, line in ipairs(lines) do
        for tag in line:gmatch("#([a-zA-Z0-9_-]+)") do
            tag_counts[tag] = (tag_counts[tag] or 0) + 1
        end
    end

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

    return tags
end

-- ==================================================================
-- LINK EXTRACTION
-- ==================================================================

-- Find all markdown files with their headings (excluding journal/)
local function get_wiki_files_with_headings()
    local result = {}

    -- Use ripgrep to find all markdown files
    local files = ripgrep({
        '""',
        "--files",
        "--type=markdown",
        "--glob=!journal/",
        WIKI_ROOT,
    })

    for _, filepath in ipairs(files) do
        local relative = get_relative_path(filepath)
        local heading = extract_heading(filepath)

        if heading then
            table.insert(result, {
                path = relative,
                title = heading,
                display = heading .. " (" .. relative .. ")",
            })
        else
            -- Use filename if no heading
            local filename = vim.fn.fnamemodify(relative, ":t:r")
            table.insert(result, {
                path = relative,
                title = filename,
                display = filename .. " (" .. relative .. ")",
            })
        end
    end

    return result
end

-- Extract links from current buffer
local function get_outbound_links()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    local links = {}
    for i, line in ipairs(lines) do
        -- Match markdown links: [text](path)
        for text, path in line:gmatch("%[([^%]]+)%]%(([^%)]+)%)") do
            table.insert(links, {
                text = text,
                path = path,
                line = i,
            })
        end
        -- Match wiki links: [[path]]
        for path in line:gmatch("%[%[([^%]]+)%]%]") do
            table.insert(links, {
                text = path,
                path = path,
                line = i,
            })
        end
    end

    return links
end

-- ==================================================================
-- BACKLINKS
-- ==================================================================

-- Find backlinks to current file
local function get_backlinks(target_path)
    local cache_key = "backlinks_" .. target_path

    if is_cache_valid(cache_key, CACHE_TTL.backlinks) then
        return cache[cache_key]
    end

    -- Escape special characters for regex
    local escaped = target_path:gsub("([%.%-%+%*%?%[%]%^%$%(%)%%])", "%%%1")

    -- Search for both markdown and wiki-style links
    local lines = ripgrep({
        '"\\(' .. escaped .. '\\)|\\[\\[' .. escaped:gsub("%.md$", "") .. '\\]\\]"',
        "--line-number",
        "--with-filename",
        "--type=markdown",
        WIKI_ROOT,
    })

    local results = {}
    for _, line in ipairs(lines) do
        local filepath, lnum, content = line:match("^([^:]+):(%d+):(.+)$")
        if filepath and lnum and content then
            local relative = get_relative_path(filepath)
            if relative ~= target_path then -- Exclude self-references
                table.insert(results, {
                    path = relative,
                    line = tonumber(lnum),
                    content = content:gsub("^%s+", ""):gsub("%s+$", ""),
                })
            end
        end
    end

    cache[cache_key] = results
    cache.timestamps[cache_key] = os.time()

    return results
end

-- ==================================================================
-- HEADING SEARCH
-- ==================================================================

-- Find all headings in wiki
local function get_all_headings()
    local lines = ripgrep({
        '"^#{1,6} .+"',
        "--line-number",
        "--with-filename",
        "--type=markdown",
        WIKI_ROOT,
    })

    local results = {}
    for _, line in ipairs(lines) do
        local filepath, lnum, content = line:match("^([^:]+):(%d+):(.+)$")
        if filepath and lnum and content then
            local relative = get_relative_path(filepath)
            local heading = content:match("^(#+%s+.+)$")
            if heading then
                table.insert(results, {
                    path = relative,
                    line = tonumber(lnum),
                    heading = heading,
                })
            end
        end
    end

    return results
end

-- ==================================================================
-- RELATED NOTES
-- ==================================================================

-- Find related notes based on shared tags and links
local function get_related_notes()
    local current_path = get_current_wiki_path()

    -- Extract tags and links from current buffer
    local buffer_tags = get_buffer_tags()
    local outbound = get_outbound_links()

    -- Create sets for comparison
    local tag_set = {}
    for _, item in ipairs(buffer_tags) do
        tag_set[item.tag] = true
    end

    local link_set = {}
    for _, link in ipairs(outbound) do
        link_set[link.path] = true
    end

    -- Find notes with overlapping tags
    local scores = {}

    -- Score by tags
    if next(tag_set) then
        for tag, _ in pairs(tag_set) do
            local lines = ripgrep({
                '"#' .. tag .. '\\b"',
                "--files-with-matches",
                "--type=markdown",
                WIKI_ROOT,
            })

            for _, filepath in ipairs(lines) do
                local relative = get_relative_path(filepath)
                if relative ~= current_path then
                    scores[relative] = (scores[relative] or 0) + 1
                end
            end
        end
    end

    -- Convert to list and sort
    local results = {}
    for path, score in pairs(scores) do
        local heading = extract_heading(vim.fn.expand(WIKI_ROOT .. "/" .. path))
        table.insert(results, {
            path = path,
            score = score,
            title = heading or vim.fn.fnamemodify(path, ":t:r"),
        })
    end

    table.sort(results, function(a, b)
        if a.score == b.score then
            return a.title < b.title
        end
        return a.score > b.score
    end)

    return results
end

-- ==================================================================
-- TELESCOPE PICKERS
-- ==================================================================

-- Link insertion picker
M.insert_link = function(opts)
    opts = opts or {}

    local files = get_wiki_files_with_headings()

    pickers.new(opts, {
        prompt_title = "Insert Wiki Link",
        finder = finders.new_table({
            results = files,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.display,
                    ordinal = entry.display,
                    path = entry.path,
                    title = entry.title,
                }
            end,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)

                if selection then
                    local link = "[" .. selection.title .. "](" .. selection.path .. ")"
                    vim.api.nvim_put({link}, "c", true, true)
                end
            end)
            return true
        end,
    }):find()
end

-- Backlinks picker
M.backlinks = function(opts)
    opts = opts or {}

    local current_path = get_current_wiki_path()
    local backlinks = get_backlinks(current_path)

    if #backlinks == 0 then
        print("No backlinks found")
        return
    end

    pickers.new(opts, {
        prompt_title = "Backlinks to " .. current_path,
        finder = finders.new_table({
            results = backlinks,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.path .. ":" .. entry.line .. " - " .. entry.content,
                    ordinal = entry.path .. " " .. entry.content,
                    filename = vim.fn.expand(WIKI_ROOT .. "/" .. entry.path),
                    lnum = entry.line,
                }
            end,
        }),
        sorter = conf.generic_sorter(opts),
        previewer = conf.grep_previewer(opts),
    }):find()
end

-- Tag search picker
M.search_tags = function(opts)
    opts = opts or {}

    local tags = get_all_tags()

    if #tags == 0 then
        print("No tags found")
        return
    end

    pickers.new(opts, {
        prompt_title = "Search Tags",
        finder = finders.new_table({
            results = tags,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = "#" .. entry.tag .. " (" .. entry.count .. ")",
                    ordinal = entry.tag,
                }
            end,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)

                if selection then
                    -- Search for files with this tag
                    M.search_by_tag(selection.value.tag)
                end
            end)
            return true
        end,
    }):find()
end

-- Search files by specific tag
M.search_by_tag = function(tag)
    local lines = ripgrep({
        '"#' .. tag .. '\\b"',
        "--files-with-matches",
        "--type=markdown",
        WIKI_ROOT,
    })

    local results = {}
    for _, filepath in ipairs(lines) do
        local relative = get_relative_path(filepath)
        local heading = extract_heading(filepath)
        table.insert(results, {
            path = relative,
            title = heading or vim.fn.fnamemodify(relative, ":t:r"),
        })
    end

    if #results == 0 then
        print("No files with tag #" .. tag)
        return
    end

    pickers.new({}, {
        prompt_title = "Files with #" .. tag,
        finder = finders.new_table({
            results = results,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.title .. " (" .. entry.path .. ")",
                    ordinal = entry.title .. " " .. entry.path,
                    filename = vim.fn.expand(WIKI_ROOT .. "/" .. entry.path),
                }
            end,
        }),
        sorter = conf.generic_sorter({}),
        previewer = conf.file_previewer({}),
    }):find()
end

-- Insert tag picker
M.insert_tag = function(opts)
    opts = opts or {}

    local tags = get_all_tags()

    if #tags == 0 then
        print("No tags found")
        return
    end

    pickers.new(opts, {
        prompt_title = "Insert Tag",
        finder = finders.new_table({
            results = tags,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = "#" .. entry.tag .. " (" .. entry.count .. ")",
                    ordinal = entry.tag,
                }
            end,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)

                if selection then
                    local tag = "#" .. selection.value.tag
                    vim.api.nvim_put({tag}, "c", true, true)
                end
            end)
            return true
        end,
    }):find()
end

-- Buffer tags picker
M.buffer_tags = function(opts)
    opts = opts or {}

    local tags = get_buffer_tags()

    if #tags == 0 then
        print("No tags in current buffer")
        return
    end

    pickers.new(opts, {
        prompt_title = "Tags in Current Buffer",
        finder = finders.new_table({
            results = tags,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = "#" .. entry.tag .. " (" .. entry.count .. ")",
                    ordinal = entry.tag,
                }
            end,
        }),
        sorter = conf.generic_sorter(opts),
    }):find()
end

-- Outbound links picker
M.outbound_links = function(opts)
    opts = opts or {}

    local links = get_outbound_links()

    if #links == 0 then
        print("No outbound links found")
        return
    end

    pickers.new(opts, {
        prompt_title = "Outbound Links",
        finder = finders.new_table({
            results = links,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.text .. " → " .. entry.path,
                    ordinal = entry.text .. " " .. entry.path,
                    filename = vim.fn.expand(WIKI_ROOT .. "/" .. entry.path),
                }
            end,
        }),
        sorter = conf.generic_sorter(opts),
        previewer = conf.file_previewer(opts),
    }):find()
end

-- Heading search picker
M.search_headings = function(opts)
    opts = opts or {}

    local headings = get_all_headings()

    if #headings == 0 then
        print("No headings found")
        return
    end

    pickers.new(opts, {
        prompt_title = "Search Headings",
        finder = finders.new_table({
            results = headings,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.heading .. " (" .. entry.path .. ":" .. entry.line .. ")",
                    ordinal = entry.heading .. " " .. entry.path,
                    filename = vim.fn.expand(WIKI_ROOT .. "/" .. entry.path),
                    lnum = entry.line,
                }
            end,
        }),
        sorter = conf.generic_sorter(opts),
        previewer = conf.grep_previewer(opts),
    }):find()
end

-- Related notes picker
M.related_notes = function(opts)
    opts = opts or {}

    local related = get_related_notes()

    if #related == 0 then
        print("No related notes found")
        return
    end

    pickers.new(opts, {
        prompt_title = "Related Notes",
        finder = finders.new_table({
            results = related,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.title .. " [" .. entry.score .. "] (" .. entry.path .. ")",
                    ordinal = entry.title .. " " .. entry.path,
                    filename = vim.fn.expand(WIKI_ROOT .. "/" .. entry.path),
                }
            end,
        }),
        sorter = conf.generic_sorter(opts),
        previewer = conf.file_previewer(opts),
    }):find()
end

-- Wiki-only grep
M.wiki_grep = function(opts)
    opts = opts or {}
    require("telescope.builtin").live_grep({
        cwd = WIKI_ROOT,
        additional_args = function()
            return { "--glob=!journal/" }
        end,
    })
end

-- ==================================================================
-- KEYMAPS
-- ==================================================================

local keys = {
    -- Link insertion
    {
        "[[",
        function() M.insert_link() end,
        mode = "i",
        desc = "Insert wiki link",
    },
    {
        "<leader>wl",
        function() M.insert_link() end,
        mode = "n",
        desc = "Insert wiki link",
    },

    -- Backlinks and links
    {
        "<leader>wb",
        function() M.backlinks() end,
        mode = "n",
        desc = "Show backlinks",
    },
    {
        "<leader>wo",
        function() M.outbound_links() end,
        mode = "n",
        desc = "Show outbound links",
    },

    -- Tags
    {
        "<leader>wt",
        function() M.search_tags() end,
        mode = "n",
        desc = "Search tags",
    },
    {
        "<leader>wT",
        function() M.buffer_tags() end,
        mode = "n",
        desc = "Show tags in buffer",
    },
    {
        "<leader>wi",
        function() M.insert_tag() end,
        mode = "n",
        desc = "Insert tag",
    },

    -- Search
    {
        "<leader>wg",
        function() M.wiki_grep() end,
        mode = "n",
        desc = "Wiki grep",
    },
    {
        "<leader>wH",
        function() M.search_headings() end,
        mode = "n",
        desc = "Search headings",
    },
    {
        "<leader>wr",
        function() M.related_notes() end,
        mode = "n",
        desc = "Find related notes",
    },
}

-- ==================================================================
-- SETUP AND AUTO-INVALIDATION
-- ==================================================================

local setup = function()
    -- Invalidate cache on file save in wiki
    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = WIKI_ROOT .. "/*.md",
        callback = function()
            invalidate_cache("tags")
            -- Invalidate backlinks cache (all entries starting with "backlinks_")
            for key in pairs(cache) do
                if key:match("^backlinks_") then
                    cache[key] = nil
                    cache.timestamps[key] = nil
                end
            end
        end,
    })

    -- Manual cache refresh command
    vim.api.nvim_create_user_command("WikiRefreshCache", function()
        for key in pairs(cache) do
            cache[key] = {}
        end
        cache.timestamps = {}
        print("Wiki cache cleared")
    end, {})
end

-- ==================================================================
-- LAZY.NVIM INTEGRATION
-- ==================================================================

return {
    lazy = function()
        return {
            "dave-vim.plugins.telescope-wiki",
            after = setup,
            keys = keys,
            ft = { "markdown" },
        }
    end,
}
