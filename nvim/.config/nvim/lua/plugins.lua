-- --- Plugins
-- Each section installs a plugin and configures it immediately.
-- Packages are added to 'runtimepath' before their setup code runs.

-- --- Utility plugins
-- Small plugins that improve editing, notifications, and keybinding discoverability.
vim.pack.add({
	{ src = "https://github.com/aevre/cmdline.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" }, -- which-key dependency
	{ src = "https://github.com/nvim-mini/mini.nvim" }, -- mini-universe dependency
})
require("mini.pairs").setup() -- automatically closes brackets and parentheses
require("mini.surround").setup() -- adds motions for changing surrounding text
require("mini.notify").setup() -- replaces the default notification UI
require("mini.statusline").setup() -- prettier statusline
require("cmdline").setup() -- hides the gutter messages, and centers the :-cmdline popup
require("which-key").setup({
	spec = {
		{ "<leader>t", group = "[T]oggle" },
		{ "<leader>s", group = "[S]earch" },

		{ "grn", desc = "Re[N]ame" },
		{ "grr", desc = "[R]eferences" },
		{ "gri", desc = "[I]mplementation" },
		{ "grt", desc = "[T]ype" },
		{ "grd", desc = "[D]efinition" },
	},
})

-- --- Colorscheme
-- Use a colorscheme from mini
vim.o.background = "light"
vim.cmd.colorscheme("miniwinter")

-- --- R.nvim, R integration
-- Adds R editing and evaluation commands to Neovim.
vim.pack.add({ { src = "https://github.com/R-nvim/R.nvim" } })
require("r").setup({
	user_maps_only = true,
	disable_cmds = { "RInsertPipe", "RInsertAssign", "RmdInsertChunk" },
})

-- --- CsvView, tabular data
-- Provides a structured view for CSV and TSV files.
vim.pack.add({ { src = "https://github.com/hat0uma/csvview.nvim" } })
require("csvview").setup()

-- Enable CsvView automatically when opening a CSV or TSV buffer.
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "csv", "tsv" },
	callback = function()
		vim.cmd("CsvViewEnable")
	end,
})

-- --- BibTeX
-- Create filepath for file with all academic references

local bibtex = vim.fn.expand("~/library.bib")

-- --- Blink, completion
-- Provides completion through LSP, filesystem paths, and BibTeX citations.
vim.pack.add({
	{ src = "https://github.com/Saghen/blink.cmp", version = "v1.10.2" },
	{ src = "https://github.com/krissen/blink-cmp-bibtex" },
})
require("blink.cmp").setup({
	sources = {
		per_filetype = { quarto = { "lsp", "path", "bibtex" } },
		providers = {
			bibtex = {
				module = "blink-cmp-bibtex",
				name = "BibTeX",
				opts = { global_files = bibtex, filetypes = { "quarto" } },
			},
		},
	},
})

-- --- Telescope, fuzzy finding
-- Provides interactive pickers for files, commands, diagnostics, symbols, and
vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" }, -- telescope dependency
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-bibtex.nvim" },
})
require("telescope").setup({
	defaults = { file_ignore_patterns = { "^.git/" } }, -- hides meaningless git-files
	pickers = { find_files = { hidden = true } }, -- makes it possible to see dotfiles
	extensions = { bibtex = { global_files = { bibtex } } },
})
require("telescope").load_extension("ui-select")
require("telescope").load_extension("bibtex")

-- Keymaps for Telescope's search and navigation pickers.
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>sh", telescope.help_tags, { desc = "[H]elp" })
vim.keymap.set("n", "<leader>sk", telescope.keymaps, { desc = "[K]eymaps" })
vim.keymap.set("n", "<leader>sf", telescope.find_files, { desc = "[F]iles" })
vim.keymap.set("n", "<leader>ss", telescope.builtin, { desc = "[S]earch" })
vim.keymap.set("n", "<leader>sg", telescope.live_grep, { desc = "[G]rep" })
vim.keymap.set("n", "<leader>sd", telescope.diagnostics, { desc = "[D]iagnostics" })
vim.keymap.set("n", "<leader>sw", telescope.lsp_dynamic_workspace_symbols, { desc = "[W]orkspace" })
vim.keymap.set("n", "<leader>s/", telescope.current_buffer_fuzzy_find, { desc = "[/]uffer" })
vim.keymap.set("n", "<leader>sb", "<cmd>Telescope bibtex<CR>", { desc = "[B]ibtex" })

-- --- Oil, file browsing
-- Provides a file explorer using buffers instead of a separate tree pane.
-- The default Oil keymaps are intentionally retained.
vim.pack.add({ { src = "https://github.com/stevearc/oil.nvim" } })
require("oil").setup()
vim.keymap.set("n", "-", "<cmd>Oil<CR>")

-- --- Spell checking
-- Configure Neovim's built-in spell checker and add convenience mappings
-- for accepting, rejecting, and reviewing spelling suggestions.
vim.o.spelllang = "nb,en_us"
vim.keymap.set("n", "zy", "zg", { desc = "[Y]es" })
vim.keymap.set("n", "zn", "zw", { desc = "[N]o" })
vim.keymap.set("n", "zs", telescope.spell_suggest, { desc = "[S]uggestions" })
vim.keymap.set("n", "<leader>ts", function()
	vim.o.spell = not vim.o.spell
	vim.notify("Spell " .. (vim.o.spell and "on" or "off"), vim.log.levels.INFO)
end, { desc = "[S]pell" })
