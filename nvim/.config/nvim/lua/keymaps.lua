local keymap = vim.keymap.set
local utils = require("utils")

-- Files
keymap("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })

-- Terminal
keymap("t", "<Esc><Esc>", "<C-\\><C-n>")
keymap("t", "<Esc>", "<C-\\><C-N>")
keymap("n", "<C-h>", "<C-w><C-h>")
keymap("n", "<C-l>", "<C-w><C-l>")

-- Telescope
local telescope = require("telescope.builtin")
keymap("n", "<leader>sh", telescope.help_tags, { desc = "[H]elp" })
keymap("n", "<leader>sk", telescope.keymaps, { desc = "[K]eymaps" })
keymap("n", "<leader>sf", telescope.find_files, { desc = "[F]iles" })
keymap("n", "<leader>ss", telescope.builtin, { desc = "[S]earch" })
keymap("n", "<leader>sg", telescope.live_grep, { desc = "[G]rep" })
keymap("n", "<leader>sd", telescope.diagnostics, { desc = "[D]iagnostics" })
keymap("n", "<leader>sw", telescope.lsp_dynamic_workspace_symbols, { desc = "[W]orkspace" })
keymap("n", "<leader>st", "<cmd>TodoTelescope<CR>", { desc = "[T]odos" })

keymap("n", "<leader>sn", function()
	telescope.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[N]eovim" })

keymap("n", "<leader>sc", function()
	require("gitsigns").setqflist("all")
end, { desc = "[C]hanges" })

-- LSP
keymap("n", "grd", vim.lsp.buf.definition, { desc = "[d]efinition" })
keymap("n", "grD", vim.lsp.buf.declaration, { desc = "[D]eclaration" })

-- Git
keymap("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "[S]tage" })
keymap("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "[R]estore" })
keymap("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "[P]review" })

-- Trouble
local trouble = require("trouble")
keymap("n", "]t", function()
	trouble.next({ jump = true })
end)
keymap("n", "[t", function()
	trouble.prev({ jump = true })
end)

-- Molten
keymap("n", "<leader>mi", "<cmd>MoltenInit<cr>", { desc = "[I]nitialize" })
keymap("n", "<leader>md", "<cmd>MoltenDeinit<cr>", { desc = "[D]einitialize" })
keymap("n", "<leader>mr", "<cmd>MoltenEvaluateCell<cr>", { desc = "[R]un" })
keymap("v", "<leader>mr", ":<C-u>MoltenEvaluateVisual<cr>gv", { desc = "[R]un" })
keymap("n", "<leader>mo", "<cmd>MoltenShowOutput<cr>", { desc = "[O]pen" })
keymap("n", "<leader>mc", "<cmd>MoltenHideOutput<cr>", { desc = "[C]lose" })
keymap("n", "<leader>me", "<cmd>MoltenEnterOutput<cr>", { desc = "[E]nter" })
keymap("n", "<leader>mx", "<cmd>MoltenInterrupt<cr>", { desc = "[X] Cancel" })

-- Quarto
keymap("n", "<leader>tq", function()
	if vim.g.quarto_preview_active then
		vim.cmd("QuartoClosePreview")
		vim.g.quarto_preview_active = false
	else
		vim.cmd("QuartoPreview")
		vim.g.quarto_preview_active = true
	end
end, { desc = "[Q]uarto" })

-- Note New - Create new hashed Quarto note in repo's src/
keymap("n", "<leader>nn", function()
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

	local hash = utils.generate_hash()
	local filepath = src_dir .. "/" .. hash .. ".qmd"
	vim.cmd.edit(filepath)
end, { desc = "[N]ote [N]ew" })

-- Note Rehash - Rename current .qmd to new hash
keymap("n", "<leader>nr", function()
	local ctx, err = utils.get_note_context()
	if not ctx then
		vim.notify(err, vim.log.levels.ERROR)
		return
	end

	local new_hash = utils.generate_hash()
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
end, { desc = "[N]ote [R]ehash" })

-- Note Delete - Delete current .qmd file
keymap("n", "<leader>nd", function()
	local ctx, err = utils.get_note_context()
	if not ctx then
		vim.notify(err, vim.log.levels.ERROR)
		return
	end

	local choice = vim.fn.confirm("Delete " .. ctx.filename .. "?", "&Yes\n&No", 2)
	if choice ~= 1 then
		return
	end

	vim.fn.delete(ctx.filepath)
	vim.cmd.bdelete()
	vim.notify("Deleted: " .. ctx.filename, vim.log.levels.INFO)
end, { desc = "[N]ote [D]elete" })

-- Toggles
keymap("n", "<leader>tz", "<cmd>ZenMode<cr>", { desc = "[Z]en" })

keymap("n", "<leader>ts", function()
	vim.o.spell = not vim.o.spell
	vim.notify("Spell " .. (vim.o.spell and "on" or "off"), vim.log.levels.INFO)
end, { desc = "[S]pell" })

-- Spell & Notes
keymap("n", "<leader>zg", "zg", { desc = "[G]ood word" })
keymap("n", "<leader>zw", "zw", { desc = "[W]rong word" })
keymap("n", "<leader>z=", "z=", { desc = "[S]uggestions" })
