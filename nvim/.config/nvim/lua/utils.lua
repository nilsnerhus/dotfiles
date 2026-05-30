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
	local ctx = M.note_context()

	local new_hash = M.generate_hash()
	local new_filepath = ctx.src_dir .. "/" .. new_hash .. ".qmd"

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

-- Create a new note from a template in the repo's templates/ directory
function M.create_note_from_template()
	local root = M.git_root()

	local templates_dir = root .. "/templates"
	if vim.fn.isdirectory(templates_dir) ~= 1 then
		vim.notify("No templates/ directory found in repo", vim.log.levels.ERROR)
		error("No templates/ directory found in repo", 0)
	end

	local src_dir = root .. "/src"
	if vim.fn.isdirectory(src_dir) ~= 1 then
		vim.notify("No src/ directory found in repo", vim.log.levels.ERROR)
		error("No src/ directory found in repo", 0)
	end

	local template_files = vim.fn.glob(templates_dir .. "/*.qmd", false, true)
	if #template_files == 0 then
		vim.notify("No .qmd templates found in templates/", vim.log.levels.ERROR)
		error("No .qmd templates found in templates/", 0)
	end

	local template_names = {}
	for _, filepath in ipairs(template_files) do
		table.insert(template_names, vim.fn.fnamemodify(filepath, ":t"))
	end

	vim.ui.select(template_names, {
		prompt = "Select template:",
	}, function(choice, idx)
		if not choice then
			return
		end

		local template_path = template_files[idx]

		vim.ui.input({
			prompt = "Filename (e.g. nve.qmd): ",
		}, function(filename)
			if not filename or filename == "" then
				return
			end

			local dest_path = src_dir .. "/" .. filename

			if vim.fn.filereadable(dest_path) == 1 then
				vim.notify("File already exists: " .. filename, vim.log.levels.ERROR)
				return
			end

			local result = vim.fn.system({ "cp", template_path, dest_path })
			if vim.v.shell_error ~= 0 then
				vim.notify("Failed to copy template: " .. result, vim.log.levels.ERROR)
				return
			end

			vim.cmd.edit(dest_path)
			vim.notify("Created " .. filename .. " from " .. choice, vim.log.levels.INFO)
		end)
	end)
end

return M
