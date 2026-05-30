local M = {}

-- Get the git root directory, failing hard if not in a git repo
function M.git_root()
	local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if vim.v.shell_error ~= 0 or not root then
		vim.notify("Not in a git repository", vim.log.levels.ERROR)
		error("Not in a git repository", 0)
	end
	return root
end

-- Returns note context, failing hard if current file is not a valid note
-- Context: {git_root, src_dir, filepath, filename, filehash}
function M.note_context()
	local filepath = vim.fn.expand("%:p")
	local filename = vim.fn.expand("%:t")

	if not filename:match("%.qmd$") then
		vim.notify("Not a .qmd file", vim.log.levels.ERROR)
		error("Not a .qmd file", 0)
	end

	local root = M.git_root()
	local src_dir = root .. "/src"

	if not filepath:match("^" .. vim.pesc(src_dir .. "/")) then
		vim.notify("File not in repo's src/ directory", vim.log.levels.ERROR)
		error("File not in repo's src/ directory", 0)
	end

	return {
		git_root = root,
		src_dir = src_dir,
		filepath = filepath,
		filename = filename,
		filehash = filename:gsub("%.qmd$", ""),
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
function M.create_new_note()
	local root = M.git_root()

	local src_dir = root .. "/src"
	if vim.fn.isdirectory(src_dir) ~= 1 then
		vim.notify("No src/ directory found in repo", vim.log.levels.ERROR)
		error("No src/ directory found in repo", 0)
	end

	local hash = M.generate_hash()
	vim.cmd.edit(src_dir .. "/" .. hash .. ".qmd")
end

-- Rehash the current note file with a new random hash
function M.rehash_note()
	local ctx, err = M.get_note_context()
	if not ctx then
		vim.notify(err, vim.log.levels.ERROR)
		return
-- Uses git mv to preserve history
-- Uses git mv to preserve history
	end

	local new_hash = M.generate_hash()
	local new_filepath = ctx.src_dir .. "/" .. new_hash .. ".qmd"

-- Uses git mv to preserve history
-- Uses git mv to preserve history
-- Uses git mv to preserve history
	local choice = vim.fn.confirm("Rehash " .. ctx.filename .. " → " .. new_hash .. ".qmd?", "&Yes\n&No", 2)
	if choice ~= 1 then
		return
	end

	if vim.bo.modified then
		vim.cmd.write()
	end

	vim.fn.system("git mv " .. vim.fn.shellescape(ctx.filepath) .. " " .. vim.fn.shellescape(new_filepath))
	vim.cmd.edit(new_filepath)
	vim.notify("Rehashed: " .. ctx.filename .. " → " .. new_hash .. ".qmd", vim.log.levels.INFO)
end

return M
