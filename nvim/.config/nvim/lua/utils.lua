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

return M
