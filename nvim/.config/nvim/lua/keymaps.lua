-- --- Languge server
-- LSP keymap for navigating to definition. Mostly used to follow links with marksman
vim.keymap.set("n", "grd", vim.lsp.buf.definition, { desc = "[d]efinition" })

-- --- Oil.nvim
-- Set oil.nvims trigger key to a dash, to navigate to the parent directory
vim.keymap.set("n", "-", "<cmd>Oil<CR>")

-- --- Telescope
-- Set a long line of telescope key bindings, all following *s*
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>sh", telescope.help_tags, { desc = "[H]elp" })
vim.keymap.set("n", "<leader>sk", telescope.keymaps, { desc = "[K]eymaps" })
vim.keymap.set("n", "<leader>sf", telescope.find_files, { desc = "[F]iles" })
vim.keymap.set("n", "<leader>ss", telescope.builtin, { desc = "[S]earch" })
vim.keymap.set("n", "<leader>sg", telescope.live_grep, { desc = "[G]rep" })
vim.keymap.set("n", "<leader>sd", telescope.diagnostics, { desc = "[D]iagnostics" })
vim.keymap.set("n", "<leader>sw", telescope.lsp_dynamic_workspace_symbols, { desc = "[W]orkspace" })
vim.keymap.set("n", "<leader>s/", telescope.current_buffer_fuzzy_find, { desc = "[/]uffer" })

-- Set the keymap for the telescope bibtex plugin
vim.keymap.set("n", "<leader>sb", "<cmd>Telescope bibtex<CR>", { desc = "[B]ibtex" })

-- --- vim.spell
-- builtin system to check for spelling mistakes
vim.keymap.set("n", "zy", "zg", { desc = "[Y]es" }) -- declare word as good spelling
vim.keymap.set("n", "zn", "zw", { desc = "[N]o" }) -- declare word as bad spelling

-- Open telescope with spelling suggestions
vim.keymap.set("n", "zs", telescope.spell_suggest, { desc = "[S]uggestions" })
vim.keymap.set("n", "<leader>ts", function()
	vim.o.spell = not vim.o.spell
	vim.notify("Spell " .. (vim.o.spell and "on" or "off"), vim.log.levels.INFO)
end, { desc = "[S]pell" })
