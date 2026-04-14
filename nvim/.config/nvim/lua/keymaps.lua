-- External services
vim.keymap.set("n", "grd", vim.lsp.buf.definition, { desc = "[d]efinition" })
vim.keymap.set("n", "grD", vim.lsp.buf.declaration, { desc = "[D]eclaration" })

-- File navigation
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>sh", telescope.help_tags, { desc = "[H]elp" })
vim.keymap.set("n", "<leader>sk", telescope.keymaps, { desc = "[K]eymaps" })
vim.keymap.set("n", "<leader>sf", telescope.find_files, { desc = "[F]iles" })
vim.keymap.set("n", "<leader>ss", telescope.builtin, { desc = "[S]earch" })
vim.keymap.set("n", "<leader>sg", telescope.live_grep, { desc = "[G]rep" })
vim.keymap.set("n", "<leader>sd", telescope.diagnostics, { desc = "[D]iagnostics" })
vim.keymap.set("n", "<leader>sw", telescope.lsp_dynamic_workspace_symbols, { desc = "[W]orkspace" })
vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<CR>", { desc = "[T]odos" })
vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "[C]ommit" })
vim.keymap.set("n", "<leader>sc", function()
	require("gitsigns").setqflist("all")
end, { desc = "[C]hanges" })

-- Source file tools
vim.keymap.set("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "[S]tage" })
vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "[R]estore" })
vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "[P]review" })

-- Notebook
vim.keymap.set("n", "<leader>tq", "<cmd>QuartoPreview<cr>", { desc = "[Q]uarto" })
vim.keymap.set("n", "<leader>zg", "zg", { desc = "[G]ood word" })
vim.keymap.set("n", "<leader>zw", "zw", { desc = "[W]rong word" })
vim.keymap.set("n", "<leader>z=", "z=", { desc = "[S]uggestions" })
vim.keymap.set("n", "<leader>ts", function()
	vim.o.spell = not vim.o.spell
	vim.notify("Spell " .. (vim.o.spell and "on" or "off"), vim.log.levels.INFO)
end, { desc = "[S]pell" })

-- Spell & Notes
keymap("n", "<leader>zg", "zg", { desc = "[G]ood word" })
keymap("n", "<leader>zw", "zw", { desc = "[W]rong word" })
keymap("n", "<leader>z=", "z=", { desc = "[S]uggestions" })

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
