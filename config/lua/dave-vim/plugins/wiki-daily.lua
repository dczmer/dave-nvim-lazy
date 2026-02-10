local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

-- ==================================================================
-- CONFIGURATION
-- ==================================================================
local M = {}

-- Wiki root and journal directory
local WIKI_ROOT = vim.fn.expand("~/vimwiki")
local JOURNAL_DIR = WIKI_ROOT .. "/journal"

-- Daily note template
local TEMPLATE = [[# %s - %s

## Tasks
- [ ]

## Notes


## Links

]]

-- ==================================================================
-- DATE UTILITIES
-- ==================================================================

-- Format date as YYYY-MM-DD
local function format_date(time)
    return os.date("%Y-%m-%d", time)
end

-- Get day of week name
local function get_day_name(time)
    return os.date("%A", time)
end

-- Parse date from filename (YYYY-MM-DD.md)
local function parse_date(filename)
    local year, month, day = filename:match("(%d%d%d%d)%-(%d%d)%-(%d%d)")
    if not year then return nil end

    return os.time({
        year = tonumber(year),
        month = tonumber(month),
        day = tonumber(day),
        hour = 12, -- Use noon to avoid DST issues
    })
end

-- Add days to a date
local function add_days(time, days)
    return time + (days * 24 * 60 * 60)
end

-- Get date from current buffer filename
local function get_buffer_date()
    local filename = vim.fn.expand("%:t")
    return parse_date(filename)
end

-- ==================================================================
-- FILE OPERATIONS
-- ==================================================================

-- Get journal filepath for date
local function get_journal_path(time)
    local date = format_date(time)
    return JOURNAL_DIR .. "/" .. date .. ".md"
end

-- Check if journal entry exists
local function journal_exists(time)
    local filepath = get_journal_path(time)
    return vim.fn.filereadable(filepath) == 1
end

-- Create journal entry with template
local function create_journal(time)
    local filepath = get_journal_path(time)
    local date = format_date(time)
    local day = get_day_name(time)

    -- Ensure journal directory exists
    vim.fn.mkdir(JOURNAL_DIR, "p")

    -- Write template
    local content = string.format(TEMPLATE, date, day)
    local file = io.open(filepath, "w")
    if file then
        file:write(content)
        file:close()
    end

    return filepath
end

-- Open journal entry (create if needed)
local function open_journal(time)
    local filepath = get_journal_path(time)

    if not journal_exists(time) then
        filepath = create_journal(time)
    end

    vim.cmd("edit " .. vim.fn.fnameescape(filepath))
end

-- ==================================================================
-- JOURNAL NAVIGATION
-- ==================================================================

-- Open today's journal
M.today = function()
    open_journal(os.time())
end

-- Open yesterday's journal
M.yesterday = function()
    local current = get_buffer_date()
    if current then
        open_journal(add_days(current, -1))
    else
        open_journal(add_days(os.time(), -1))
    end
end

-- Open tomorrow's journal
M.tomorrow = function()
    local current = get_buffer_date()
    if current then
        open_journal(add_days(current, 1))
    else
        open_journal(add_days(os.time(), 1))
    end
end

-- ==================================================================
-- JOURNAL BROWSER
-- ==================================================================

-- Get all journal entries
local function get_journal_entries()
    local entries = {}
    local handle = io.popen("ls " .. vim.fn.shellescape(JOURNAL_DIR) .. "/*.md 2>/dev/null")
    if not handle then return entries end

    for filepath in handle:lines() do
        local filename = vim.fn.fnamemodify(filepath, ":t")
        local time = parse_date(filename)
        if time then
            entries[#entries + 1] = {
                filepath = filepath,
                filename = filename,
                date = format_date(time),
                day = get_day_name(time),
                time = time,
            }
        end
    end
    handle:close()

    -- Sort by date (newest first)
    table.sort(entries, function(a, b)
        return a.time > b.time
    end)

    return entries
end

-- Journal browser picker
M.browse = function(opts)
    opts = opts or {}

    local entries = get_journal_entries()

    if #entries == 0 then
        print("No journal entries found")
        return
    end

    pickers.new(opts, {
        prompt_title = "Journal Entries",
        finder = finders.new_table({
            results = entries,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.date .. " - " .. entry.day,
                    ordinal = entry.date,
                    filename = entry.filepath,
                }
            end,
        }),
        sorter = conf.generic_sorter(opts),
        previewer = conf.file_previewer(opts),
    }):find()
end

-- ==================================================================
-- CALENDAR INTEGRATION
-- ==================================================================

-- Calendar picker (simple date selection)
M.calendar = function()
    -- Prompt for date input
    vim.ui.input({
        prompt = "Enter date (YYYY-MM-DD) or offset (+1, -1, etc): ",
        default = format_date(os.time()),
    }, function(input)
        if not input then return end

        local time
        if input:match("^[+-]?%d+$") then
            -- Offset from today
            local offset = tonumber(input)
            time = add_days(os.time(), offset)
        else
            -- Parse date
            local year, month, day = input:match("(%d%d%d%d)%-(%d%d)%-(%d%d)")
            if year then
                time = os.time({
                    year = tonumber(year),
                    month = tonumber(month),
                    day = tonumber(day),
                    hour = 12,
                })
            end
        end

        if time then
            open_journal(time)
        else
            print("Invalid date format. Use YYYY-MM-DD or offset (+1, -1)")
        end
    end)
end

-- ==================================================================
-- CALENDAR.VIM INTEGRATION
-- ==================================================================

local setup_calendar = function()
    -- Configure calendar.vim for diary integration
    vim.g.calendar_diary = JOURNAL_DIR

    -- Create autocmd for calendar date selection
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "calendar",
        callback = function()
            -- Map <CR> to open journal entry
            vim.keymap.set("n", "<CR>", function()
                local date = vim.fn["calendar#day#get_ymd"]()
                if date then
                    local time = os.time({
                        year = date.year,
                        month = date.month,
                        day = date.day,
                        hour = 12,
                    })
                    vim.cmd("quit") -- Close calendar
                    open_journal(time)
                end
            end, { buffer = true, desc = "Open journal entry" })
        end,
    })
end

-- ==================================================================
-- KEYMAPS
-- ==================================================================

local keys = {
    -- Daily navigation
    {
        "<leader>wj",
        function() M.today() end,
        mode = "n",
        desc = "Today's journal",
    },
    {
        "<leader>wh",
        function() M.yesterday() end,
        mode = "n",
        desc = "Yesterday's journal",
    },
    {
        "<leader>wL",
        function() M.tomorrow() end,
        mode = "n",
        desc = "Tomorrow's journal",
    },

    -- Journal browser
    {
        "<leader>wJ",
        function() M.browse() end,
        mode = "n",
        desc = "Browse journal entries",
    },

    -- Calendar
    {
        "<leader>wc",
        function() M.calendar() end,
        mode = "n",
        desc = "Calendar date picker",
    },
}

-- ==================================================================
-- SETUP
-- ==================================================================

local setup = function()
    setup_calendar()

    -- Ensure journal directory exists
    vim.fn.mkdir(JOURNAL_DIR, "p")

    -- Add command for quick journal access
    vim.api.nvim_create_user_command("WikiToday", M.today, {})
    vim.api.nvim_create_user_command("WikiYesterday", M.yesterday, {})
    vim.api.nvim_create_user_command("WikiTomorrow", M.tomorrow, {})
    vim.api.nvim_create_user_command("WikiJournal", M.browse, {})
end

-- ==================================================================
-- LAZY.NVIM INTEGRATION
-- ==================================================================

return {
    lazy = function()
        return {
            "dave-vim.plugins.wiki-daily",
            after = setup,
            keys = keys,
            ft = { "markdown" },
        }
    end,
}
