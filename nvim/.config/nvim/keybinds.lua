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

-- [[ Spell checking keymaps ]]
-- ]s / [s - Next/previous misspelled word (built-in)
-- z= - Show suggestions for word under cursor (built-in)
-- zg - Add word to spellfile (good word)
-- zw - Add word to spellfile (bad word)
-- zug / zuw - Remove word from spellfile
vim.keymap.set("n", "<leader>zg", "zg", { desc = "Add word to spellfile as [G]ood" })
vim.keymap.set("n", "<leader>zw", "zw", { desc = "Add word to spellfile as [W]rong" })
vim.keymap.set("n", "<leader>z=", "z=", { desc = "Show spell [S]uggestions" })

-- Spell checking toggle (<leader>ts for [T]oggle [S]pell)
vim.keymap.set("n", "<leader>ts", function()
	vim.o.spell = not vim.o.spell
	local status = vim.o.spell and "enabled" or "disabled"
	vim.notify("Spell checking " .. status, vim.log.levels.INFO)
end, { desc = "[T]oggle [S]pell checking" })

-- Spell search with telescope (<leader>zs for [Z]pell [S]earch)
vim.keymap.set("n", "<leader>zs", function()
	require("util.spell").spell_picker()
end, { desc = "[Z]pell [S]earch with telescope" })
