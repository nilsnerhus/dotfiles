-- External services
vim.keymap.set("n", "grd", vim.lsp.buf.definition, { desc = "[d]efinition" })
vim.keymap.set("n", "grD", vim.lsp.buf.declaration, { desc = "[D]eclaration" })

-- File navigation
vim.keymap.set("n", "-", "<cmd>Oil<CR>")

local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>sh", telescope.help_tags, { desc = "[H]elp" })
vim.keymap.set("n", "<leader>sk", telescope.keymaps, { desc = "[K]eymaps" })
vim.keymap.set("n", "<leader>sf", telescope.find_files, { desc = "[F]iles" })
vim.keymap.set("n", "<leader>ss", telescope.builtin, { desc = "[S]earch" })
vim.keymap.set("n", "<leader>sg", telescope.live_grep, { desc = "[G]rep" })
vim.keymap.set("n", "<leader>sd", telescope.diagnostics, { desc = "[D]iagnostics" })
vim.keymap.set("n", "<leader>sw", telescope.lsp_dynamic_workspace_symbols, { desc = "[W]orkspace" })
vim.keymap.set("n", "<leader>s/", telescope.current_buffer_fuzzy_find, { desc = "[/]uffer" })

-- Source file tools
vim.keymap.set("n", "<leader>sb", "<cmd>Telescope bibtex<CR>", { desc = "[B]ibtex" })
vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<CR>", { desc = "[T]odos" })
vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "[C]ommit" })
vim.keymap.set("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "[S]tage" })
vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "[R]estore" })
vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "[P]review" })
vim.keymap.set("n", "<leader>sc", function()
	require("gitsigns").setqflist("all")
end, { desc = "[C]hanges" })

-- Notebook
vim.keymap.set("n", "<leader>tq", "<cmd>QuartoPreview<cr>", { desc = "[Q]uarto" })
vim.keymap.set("n", "<leader>zg", "zg", { desc = "[G]ood word" })
vim.keymap.set("n", "<leader>zw", "zw", { desc = "[W]rong word" })
vim.keymap.set("n", "<leader>z=", "z=", { desc = "[S]uggestions" })
vim.keymap.set("n", "<leader>ts", function()
	vim.o.spell = not vim.o.spell
	vim.notify("Spell " .. (vim.o.spell and "on" or "off"), vim.log.levels.INFO)
end, { desc = "[S]pell" })

-- Neovim
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>")
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")
vim.keymap.set("n", "<leader>tz", "<cmd>ZenMode<cr>", { desc = "[Z]en" })
