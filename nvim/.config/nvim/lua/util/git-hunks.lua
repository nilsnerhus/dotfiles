-- Telescope picker for git hunks across all files
-- Uses gitsigns' internal API for exact match with :Gitsigns setqflist all

local M = {}

local function get_first_non_empty_line(lines)
	if not lines or #lines == 0 then
		return nil
	end
	for _, line in ipairs(lines) do
		if line ~= "" then
			return line
		end
	end
	return nil
end

local function get_preview(hunk)
	local preview = get_first_non_empty_line(hunk.added and hunk.added.lines)
	if preview then
		return preview
	end
	preview = get_first_non_empty_line(hunk.removed and hunk.removed.lines)
	if preview then
		return preview
	end
	return ""
end

local function format_hunk(hunk, filename)
	return {
		filename = filename,
		lnum = hunk.added.start,
		col = 1,
		text = string.format("%s %d: %s", hunk.type, hunk.added.count or 0, get_preview(hunk)),
		type = hunk.type,
		head = hunk.head,
	}
end

local function collect_repos(cache)
	local repos = {}
	for _, bcache in pairs(cache) do
		local repo = bcache.git_obj.repo
		if repo then
			repos[repo.gitdir] = repo
		end
	end
	return repos
end

local function add_current_repo(repos, git)
	local uv = vim.uv or vim.loop
	local cwd = uv.cwd()
	local current_repo = git.Repo.get(cwd)
	if current_repo and not repos[current_repo.gitdir] then
		repos[current_repo.gitdir] = current_repo
	end
	return repos
end

local function process_file(repo, filename, run_diff, util, uv)
	local f_abs = repo.toplevel .. "/" .. filename
	local stat, err = uv.fs_stat(f_abs)
	if not stat then
		return nil, string.format("Failed to stat %s: %s", f_abs, err or "unknown error")
	end
	if stat.type ~= "file" then
		return nil, nil
	end

	local staged_text, staged_err = repo:get_show_text(":0:" .. filename)
	if not staged_text then
		return nil, string.format("Failed to get staged text for %s: %s", filename, staged_err or "unknown error")
	end

	local current_text, read_err = util.file_lines(f_abs)
	if not current_text then
		return nil, string.format("Failed to read %s: %s", f_abs, read_err or "unknown error")
	end

	return run_diff(staged_text, current_text), nil
end

local function create_picker(entries)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local make_entry = require("telescope.make_entry")

	return pickers.new({}, {
		prompt_title = "Git Hunks",
		finder = finders.new_table({
			results = entries,
			entry_maker = make_entry.gen_from_quickfix(),
		}),
		previewer = conf.grep_previewer({}),
		sorter = conf.generic_sorter({}),
	})
end

function M.git_hunks()
	local utils = require("telescope.utils")

	local ok, async = pcall(require, "gitsigns.async")
	if not ok then
		utils.notify("Gitsigns async not available", vim.log.levels.ERROR)
		return
	end

	async.run(function()
		local cache = require("gitsigns.cache").cache
		local git = require("gitsigns.git")
		local run_diff = require("gitsigns.diff")
		local util = require("gitsigns.util")
		local uv = vim.uv or vim.loop

		local repos = add_current_repo(collect_repos(cache), git)
		local hunks = {}
		local errors = {}

		for _, repo in pairs(repos) do
			local files = repo:files_changed(nil, true)

			for _, f in ipairs(files) do
				local file_hunks, err = process_file(repo, f, run_diff, util, uv)

				if err then
					table.insert(errors, err)
				elseif file_hunks then
					for _, h in ipairs(file_hunks) do
						table.insert(hunks, format_hunk(h, repo.toplevel .. "/" .. f))
					end
				end
			end
		end

		async.schedule()

		if #hunks == 0 then
			if #errors > 0 then
				utils.notify("No git hunks found (" .. #errors .. " errors)", vim.log.levels.WARN)
			else
				utils.notify("No git hunks found", vim.log.levels.WARN)
			end
			return
		end

		local entries = {}
		for _, h in ipairs(hunks) do
			table.insert(entries, {
				filename = h.filename,
				lnum = h.lnum,
				col = h.col,
				text = h.text,
			})
		end

		create_picker(entries):find()
	end)
end

return M
