local M = {}

-- Returns note context or nil, error_msg
-- Context: {git_root, src_dir, filepath, filename, filehash}
function M.get_note_context()
	local filepath = vim.fn.expand("%:p")
	local filename = vim.fn.expand("%:t")

	-- Check if .qmd file
	if not filename:match("%.qmd$") then
		return nil, "Not a .qmd file"
	end

	-- Get git root
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if vim.v.shell_error ~= 0 or not git_root then
		return nil, "Not in a git repository"
	end

	-- Check if in src/ directory
	local src_dir = git_root .. "/src"
	if not filepath:match("^" .. vim.pesc(src_dir .. "/")) then
		return nil, "File not in repo's src/ directory"
	end

	-- Extract hash from filename (everything before .qmd)
	local filehash = filename:gsub("%.qmd$", "")

	return {
		git_root = git_root,
		src_dir = src_dir,
		filepath = filepath,
		filename = filename,
		filehash = filehash,
	}
end

-- Generate 6-char hex hash
function M.generate_hash()
	math.randomseed(os.time())
	local hash = ""
	for _ = 1, 6 do
		hash = hash .. string.format("%x", math.random(0, 15))
	end
	return hash
end

-- Create a new note with a random hash filename
-- Finds git root, validates src/ directory, generates hash, and opens the file
function M.create_new_note()
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if vim.v.shell_error ~= 0 or not git_root then
		vim.notify("Not in a git repository", vim.log.levels.ERROR)
		return
	end

	local src_dir = git_root .. "/src"
	if vim.fn.isdirectory(src_dir) ~= 1 then
		vim.notify("No src/ directory found in repo", vim.log.levels.ERROR)
		return
	end

	local hash = M.generate_hash()
	local filepath = src_dir .. "/" .. hash .. ".qmd"
	vim.cmd.edit(filepath)
end

-- Rehash the current note file with a new random hash
-- Uses git mv to preserve history
function M.rehash_note()
	local ctx, err = M.get_note_context()
	if not ctx then
		vim.notify(err, vim.log.levels.ERROR)
		return
	end

	local new_hash = M.generate_hash()
	local new_filepath = ctx.src_dir .. "/" .. new_hash .. ".qmd"

	local choice = vim.fn.confirm("Rehash " .. ctx.filename .. " → " .. new_hash .. ".qmd?", "&Yes\n&No", 2)
	if choice ~= 1 then
		return
	end

	-- Auto-save before rehashing
	if vim.bo.modified then
		vim.cmd.write()
	end

	vim.fn.system("git mv " .. vim.fn.shellescape(ctx.filepath) .. " " .. vim.fn.shellescape(new_filepath))
	vim.cmd.edit(new_filepath)
	vim.notify("Rehashed: " .. ctx.filename .. " → " .. new_hash .. ".qmd", vim.log.levels.INFO)
end

return M
