local M = {}

-- ==================================================================
-- CONFIGURATION
-- ==================================================================

local wiki_root = vim.fn.expand("~/vimwiki")

M.get_wiki_root = function()
	return wiki_root
end

M.get_journal_dir = function()
	return wiki_root .. "/journal"
end

-- ==================================================================
-- CACHE INFRASTRUCTURE
-- ==================================================================

local cache = {
	tags = {},
	backlinks = {},
	headings = {},
	timestamps = {},
}

M.CACHE_TTL = {
	tags = 600,
	backlinks = 300,
}

M.is_cache_valid = function(key, ttl)
	if not cache.timestamps[key] then
		return false
	end
	local elapsed = os.time() - cache.timestamps[key]
	return elapsed < ttl
end

M.invalidate_cache = function(key)
	cache[key] = {}
	cache.timestamps[key] = nil
end

M.invalidate_all_cache = function()
	for key in pairs(cache) do
		if key ~= "timestamps" then
			cache[key] = {}
		end
	end
	cache.timestamps = {}
end

-- ==================================================================
-- UTILITY FUNCTIONS
-- ==================================================================

M.get_relative_path = function(filepath)
	local expanded = vim.fn.expand(filepath)
	local root = vim.fn.expand(wiki_root)
	if expanded:sub(1, #root) == root then
		return expanded:sub(#root + 2)
	end
	return expanded
end

M.get_current_wiki_path = function()
	return M.get_relative_path(vim.api.nvim_buf_get_name(0))
end

M.extract_heading = function(filepath)
	local file = io.open(filepath, "r")
	if not file then
		return nil
	end

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

M.ripgrep = function(args)
	local cmd = "rg " .. table.concat(args, " ")
	local handle = io.popen(cmd)
	if not handle then
		return {}
	end

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

M.get_all_tags = function()
	if M.is_cache_valid("tags", M.CACHE_TTL.tags) then
		return cache.tags
	end

	local lines = M.ripgrep({
		'"#[a-zA-Z0-9_-]+"',
		"--only-matching",
		"--no-filename",
		"--no-line-number",
		"--type=markdown",
		wiki_root,
	})

	local tag_counts = {}
	for _, line in ipairs(lines) do
		local tag = line:match("#([a-zA-Z0-9_-]+)")
		if tag then
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

	cache.tags = tags
	cache.timestamps.tags = os.time()

	return tags
end

M.get_buffer_tags = function()
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
-- SETUP
-- ==================================================================

M.setup = function()
	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = wiki_root .. "/*.md",
		callback = function()
			M.invalidate_cache("tags")
			for key in pairs(cache) do
				if key ~= "timestamps" and key:match("^backlinks_") then
					cache[key] = nil
					cache.timestamps[key] = nil
				end
			end
		end,
	})

	vim.api.nvim_create_user_command("WikiRefreshCache", function()
		M.invalidate_all_cache()
		print("Wiki cache cleared")
	end, {})
end

return M
