local keymap = vim.keymap.set

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
	require("util.git-hunks").git_hunks()
end, { desc = "[C]hanges" })

-- LSP
keymap("n", "grd", vim.lsp.buf.definition, { desc = "Definition" })
keymap("n", "grD", vim.lsp.buf.declaration, { desc = "Declaration" })
keymap("n", "grr", telescope.lsp_references, { desc = "References" })
keymap("n", "gri", telescope.lsp_implementations, { desc = "Implementation" })
keymap("n", "grt", telescope.lsp_type_definitions, { desc = "Type Definition" })
keymap("n", "gO", telescope.lsp_document_symbols, { desc = "Document Symbols" })
keymap("n", "grn", vim.lsp.buf.rename, { desc = "Rename" })
keymap("n", "gra", vim.lsp.buf.code_action, { desc = "Code Action" })

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

keymap("n", "<leader>zs", function()
	require("util.spell").spell_picker()
end, { desc = "[S]earch" })
