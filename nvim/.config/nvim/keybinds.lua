-- FIX: Make it throw an error when src/ is not found, and not create the dir
local function create_quarto_note()
	-- Get git repo root
	local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
	if vim.v.shell_error ~= 0 then
		vim.notify("Not in a git repository", vim.log.levels.ERROR)
		return
	end

	-- Check if src/ directory exists
	local src_dir = git_root .. "/src"
	if vim.fn.isdirectory(src_dir) == 0 then
		vim.notify("src/ directory does not exist in repo root", vim.log.levels.ERROR)
		return
	end

	-- Generate random 6-character hex string
	math.randomseed(os.time() + math.random(0, 1000000))
	local random_hash = string.format("%06x", math.random(0, 0xffffff))

	-- Check if file already exists
	local filepath = src_dir .. "/" .. random_hash .. ".qmd"
	if vim.fn.filereadable(filepath) == 1 then
		vim.notify("File " .. random_hash .. ".qmd already exists", vim.log.levels.ERROR)
		return
	end

	-- Create empty file
	vim.fn.writefile({}, filepath)

	-- Open the file in current buffer
	vim.cmd("edit " .. filepath)

	-- Show success message
	vim.notify("Created: src/" .. random_hash .. ".qmd", vim.log.levels.INFO)
end

-- Keybind: <leader>nn to create new quarto note
vim.keymap.set("n", "<leader>nn", create_quarto_note, { desc = "Create new quarto [N]ote with random [N]ame" })
