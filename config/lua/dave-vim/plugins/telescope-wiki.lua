local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local wiki = require("dave-vim.utils.wiki")

-- ==================================================================
-- MODULE
-- ==================================================================
local M = {}

-- ==================================================================
-- LINK EXTRACTION
-- ==================================================================

local function get_wiki_files_with_headings()
	local result = {}

	local files = wiki.ripgrep({
		'""',
		"--files",
		"--type=markdown",
		"--glob=!journal/",
		wiki.get_wiki_root(),
	})

	for _, filepath in ipairs(files) do
		local relative = wiki.get_relative_path(filepath)
		local heading = wiki.extract_heading(filepath)

		if heading then
			table.insert(result, {
				path = relative,
				title = heading,
				display = heading .. " (" .. relative .. ")",
			})
		else
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

local function get_outbound_links()
	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	local links = {}
	for i, line in ipairs(lines) do
		for text, path in line:gmatch("%[([^%]]+)%]%(([^%)]+)%)") do
			table.insert(links, {
				text = text,
				path = path,
				line = i,
			})
		end
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

local function get_backlinks(target_path)
	local cache_key = "backlinks_" .. target_path

	if wiki.is_cache_valid(cache_key, wiki.CACHE_TTL.backlinks) then
		local cache_data = rawget(_G, "_wiki_backlinks_cache") or {}
		return cache_data[cache_key] or {}
	end

	local escaped = target_path:gsub("([%.%-%+%*%?%[%]%^%$%(%)%%])", "%%%1")

	local lines = wiki.ripgrep({
		'"\\(' .. escaped .. "\\)|\\[\\[" .. escaped:gsub("%.md$", "") .. '\\]\\]"',
		"--line-number",
		"--with-filename",
		"--type=markdown",
		wiki.get_wiki_root(),
	})

	local results = {}
	for _, line in ipairs(lines) do
		local filepath, lnum, content = line:match("^([^:]+):(%d+):(.+)$")
		if filepath and lnum and content then
			local relative = wiki.get_relative_path(filepath)
			if relative ~= target_path then
				table.insert(results, {
					path = relative,
					line = tonumber(lnum),
					content = content:gsub("^%s+", ""):gsub("%s+$", ""),
				})
			end
		end
	end

	local cache_data = rawget(_G, "_wiki_backlinks_cache") or {}
	cache_data[cache_key] = results
	_G._wiki_backlinks_cache = cache_data

	return results
end

-- ==================================================================
-- HEADING SEARCH
-- ==================================================================

local function get_all_headings()
	local lines = wiki.ripgrep({
		'"^#{1,6} .+"',
		"--line-number",
		"--with-filename",
		"--type=markdown",
		wiki.get_wiki_root(),
	})

	local results = {}
	for _, line in ipairs(lines) do
		local filepath, lnum, content = line:match("^([^:]+):(%d+):(.+)$")
		if filepath and lnum and content then
			local relative = wiki.get_relative_path(filepath)
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

local function get_related_notes()
	local current_path = wiki.get_current_wiki_path()

	local buffer_tags = wiki.get_buffer_tags()

	local tag_set = {}
	for _, item in ipairs(buffer_tags) do
		tag_set[item.tag] = true
	end

	local scores = {}

	if next(tag_set) then
		for tag, _ in pairs(tag_set) do
			local lines = wiki.ripgrep({
				'"#' .. tag .. '\\b"',
				"--files-with-matches",
				"--type=markdown",
				wiki.get_wiki_root(),
			})

			for _, filepath in ipairs(lines) do
				local relative = wiki.get_relative_path(filepath)
				if relative ~= current_path then
					scores[relative] = (scores[relative] or 0) + 1
				end
			end
		end
	end

	local results = {}
	for path, score in pairs(scores) do
		local heading = wiki.extract_heading(vim.fn.expand(wiki.get_wiki_root() .. "/" .. path))
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

M.insert_link = function(opts)
	opts = opts or {}

	local files = get_wiki_files_with_headings()

	pickers
		.new(opts, {
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
						vim.api.nvim_put({ link }, "c", true, true)
					end
				end)
				return true
			end,
		})
		:find()
end

M.backlinks = function(opts)
	opts = opts or {}

	local current_path = wiki.get_current_wiki_path()
	local backlinks = get_backlinks(current_path)

	if #backlinks == 0 then
		print("No backlinks found")
		return
	end

	pickers
		.new(opts, {
			prompt_title = "Backlinks to " .. current_path,
			finder = finders.new_table({
				results = backlinks,
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry.path .. ":" .. entry.line .. " - " .. entry.content,
						ordinal = entry.path .. " " .. entry.content,
						filename = vim.fn.expand(wiki.get_wiki_root() .. "/" .. entry.path),
						lnum = entry.line,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			previewer = conf.grep_previewer(opts),
		})
		:find()
end

M.search_tags = function(opts)
	opts = opts or {}

	local tags = wiki.get_all_tags()

	if #tags == 0 then
		print("No tags found")
		return
	end

	pickers
		.new(opts, {
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
						M.search_by_tag(selection.value.tag)
					end
				end)
				return true
			end,
		})
		:find()
end

M.search_by_tag = function(tag)
	local lines = wiki.ripgrep({
		'"#' .. tag .. '\\b"',
		"--files-with-matches",
		"--type=markdown",
		wiki.get_wiki_root(),
	})

	local results = {}
	for _, filepath in ipairs(lines) do
		local relative = wiki.get_relative_path(filepath)
		local heading = wiki.extract_heading(filepath)
		table.insert(results, {
			path = relative,
			title = heading or vim.fn.fnamemodify(relative, ":t:r"),
		})
	end

	if #results == 0 then
		print("No files with tag #" .. tag)
		return
	end

	pickers
		.new({}, {
			prompt_title = "Files with #" .. tag,
			finder = finders.new_table({
				results = results,
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry.title .. " (" .. entry.path .. ")",
						ordinal = entry.title .. " " .. entry.path,
						filename = vim.fn.expand(wiki.get_wiki_root() .. "/" .. entry.path),
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			previewer = conf.file_previewer({}),
		})
		:find()
end

M.insert_tag = function(opts)
	opts = opts or {}

	local tags = wiki.get_all_tags()

	if #tags == 0 then
		print("No tags found")
		return
	end

	pickers
		.new(opts, {
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
						vim.api.nvim_put({ tag }, "c", true, true)
					end
				end)
				return true
			end,
		})
		:find()
end

M.buffer_tags = function(opts)
	opts = opts or {}

	local tags = wiki.get_buffer_tags()

	if #tags == 0 then
		print("No tags in current buffer")
		return
	end

	pickers
		.new(opts, {
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
		})
		:find()
end

M.outbound_links = function(opts)
	opts = opts or {}

	local links = get_outbound_links()

	if #links == 0 then
		print("No outbound links found")
		return
	end

	pickers
		.new(opts, {
			prompt_title = "Outbound Links",
			finder = finders.new_table({
				results = links,
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry.text .. " → " .. entry.path,
						ordinal = entry.text .. " " .. entry.path,
						filename = vim.fn.expand(wiki.get_wiki_root() .. "/" .. entry.path),
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			previewer = conf.file_previewer(opts),
		})
		:find()
end

M.search_headings = function(opts)
	opts = opts or {}

	local headings = get_all_headings()

	if #headings == 0 then
		print("No headings found")
		return
	end

	pickers
		.new(opts, {
			prompt_title = "Search Headings",
			finder = finders.new_table({
				results = headings,
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry.heading .. " (" .. entry.path .. ":" .. entry.line .. ")",
						ordinal = entry.heading .. " " .. entry.path,
						filename = vim.fn.expand(wiki.get_wiki_root() .. "/" .. entry.path),
						lnum = entry.line,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			previewer = conf.grep_previewer(opts),
		})
		:find()
end

M.related_notes = function(opts)
	opts = opts or {}

	local related = get_related_notes()

	if #related == 0 then
		print("No related notes found")
		return
	end

	pickers
		.new(opts, {
			prompt_title = "Related Notes",
			finder = finders.new_table({
				results = related,
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry.title .. " [" .. entry.score .. "] (" .. entry.path .. ")",
						ordinal = entry.title .. " " .. entry.path,
						filename = vim.fn.expand(wiki.get_wiki_root() .. "/" .. entry.path),
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			previewer = conf.file_previewer(opts),
		})
		:find()
end

M.wiki_grep = function(opts)
	opts = opts or {}
	require("telescope.builtin").live_grep({
		cwd = wiki.get_wiki_root(),
		additional_args = function()
			return { "--glob=!journal/" }
		end,
	})
end

-- ==================================================================
-- KEYMAPS
-- ==================================================================

local keys = {
	{
		"[[",
		function()
			M.insert_link()
		end,
		mode = "i",
		desc = "Insert wiki link",
	},
	{
		"<leader>wl",
		function()
			M.insert_link()
		end,
		mode = "n",
		desc = "Insert wiki link",
	},

	{
		"<leader>wb",
		function()
			M.backlinks()
		end,
		mode = "n",
		desc = "Show backlinks",
	},
	{
		"<leader>wo",
		function()
			M.outbound_links()
		end,
		mode = "n",
		desc = "Show outbound links",
	},

	{
		"<leader>wt",
		function()
			M.search_tags()
		end,
		mode = "n",
		desc = "Search tags",
	},
	{
		"<leader>wT",
		function()
			M.buffer_tags()
		end,
		mode = "n",
		desc = "Show tags in buffer",
	},
	{
		"<leader>wi",
		function()
			M.insert_tag()
		end,
		mode = "n",
		desc = "Insert tag",
	},

	{
		"<leader>wg",
		function()
			M.wiki_grep()
		end,
		mode = "n",
		desc = "Wiki grep",
	},
	{
		"<leader>wH",
		function()
			M.search_headings()
		end,
		mode = "n",
		desc = "Search headings",
	},
	{
		"<leader>wr",
		function()
			M.related_notes()
		end,
		mode = "n",
		desc = "Find related notes",
	},
}

-- ==================================================================
-- LAZY.NVIM INTEGRATION
-- ==================================================================

local setup = function()
	wiki.setup()
end

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
