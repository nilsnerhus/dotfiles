-- Install plugins and configure them below.
-- Each plugin group adds its package before requiring it, so the package is
-- available on 'runtimepath' when its setup code runs.

-- Colorscheme
vim.pack.add({
	{ src = "https://github.com/d00h/nvim-rusticated" },
})

vim.cmd.colorscheme("rusticated")

-- CSV files
-- Highlight the first line of CSV and TSV buffers.
vim.api.nvim_set_hl(0, "CsvViewHeaderLine", { bold = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.api.nvim_set_hl(0, "CsvViewHeaderLine", { bold = true })
	end,
})

-- Enable CsvView automatically for CSV and TSV buffers.
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "csv", "tsv" },
	callback = function()
		vim.cmd("CsvViewEnable")
	end,
})

-- Diagnostics
vim.pack.add({
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
})
require("tiny-inline-diagnostic").setup()

-- Completion
vim.pack.add({
	{ src = "https://github.com/Saghen/blink.cmp", version = "v1.10.2" },
	{ src = "https://github.com/krissen/blink-cmp-bibtex" },
})
require("blink.cmp").setup({
	sources = {
		default = { "lsp", "path", "snippets", "buffer", "bibtex" },
		per_filetype = {
			markdown = { "lsp", "bibtex" },
			quarto = { "lsp", "bibtex" },
		},
		providers = {
			bibtex = {
				module = "blink-cmp-bibtex",
				name = "BibTeX",
				async = true,
				min_keyword_length = 2,
				opts = {
					global_files = { vim.fn.expand("~/library.bib") },
					filetypes = { "markdown", "typst", "quarto" },
					source_indicator = false,
				},
			},
		},
	},
})

-- Telescope: searching, file navigation, and BibTeX lookup.
vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" }, -- telescope dependency
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-bibtex.nvim" },
})
local telescope = require("telescope.builtin")
require("telescope").setup({
	defaults = {
		layout_strategy = "horizontal",
		wrap_results = true,
		layout_config = { horizontal = { preview_width = 0.5 } },
		file_ignore_patterns = { "^.git/" },
	},
	pickers = { find_files = { hidden = true } },
	extensions = {
		bibtex = {
			global_files = { vim.fn.expand("~/library.bib") },
			depth = 0,
			context = false,
			search_keys = { "author", "year", "title", "date" },
		},
	},
})
require("telescope").load_extension("ui-select")
require("telescope").load_extension("bibtex")

vim.keymap.set("n", "<leader>sh", telescope.help_tags, { desc = "[H]elp" })
vim.keymap.set("n", "<leader>sk", telescope.keymaps, { desc = "[K]eymaps" })
vim.keymap.set("n", "<leader>sf", telescope.find_files, { desc = "[F]iles" })
vim.keymap.set("n", "<leader>ss", telescope.builtin, { desc = "[S]earch" })
vim.keymap.set("n", "<leader>sg", telescope.live_grep, { desc = "[G]rep" })
vim.keymap.set("n", "<leader>sd", telescope.diagnostics, { desc = "[D]iagnostics" })
vim.keymap.set("n", "<leader>sw", telescope.lsp_dynamic_workspace_symbols, { desc = "[W]orkspace" })
vim.keymap.set("n", "<leader>s/", telescope.current_buffer_fuzzy_find, { desc = "[/]uffer" })
vim.keymap.set("n", "<leader>sb", "<cmd>Telescope bibtex<CR>", { desc = "[B]ibtex" })

-- Oil: file browsing.
vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
})
require("oil").setup({
	use_default_keymaps = false,
	keymaps = {
		["<CR>"] = "actions.select",
		["-"] = "actions.parent",
		["<C-s>"] = { "actions.select", opts = { vertical = true } },
		["<C-r>"] = "actions.refresh",
		["g."] = "actions.toggle_hidden",
	},
})
vim.keymap.set("n", "-", "<cmd>Oil<CR>")

-- R and notebook files
vim.pack.add({
	{ src = "https://github.com/hat0uma/csvview.nvim" },
	{ src = "https://github.com/R-nvim/R.nvim" },
})
require("csvview").setup({
	view = { display_mode = "border" },
})
require("r").setup({
	user_maps_only = true,
	disable_cmds = { "RInsertPipe", "RInsertAssign", "RmdInsertChunk" },
})

-- Spell checking
-- Built-in system for checking spelling mistakes.
vim.o.spelllang = "nb,en_us"
vim.keymap.set("n", "zy", "zg", { desc = "[Y]es" })
vim.keymap.set("n", "zn", "zw", { desc = "[N]o" })
vim.keymap.set("n", "zs", telescope.spell_suggest, { desc = "[S]uggestions" })
vim.keymap.set("n", "<leader>ts", function()
	vim.o.spell = not vim.o.spell
	vim.notify("Spell " .. (vim.o.spell and "on" or "off"), vim.log.levels.INFO)
end, { desc = "[S]pell" })

-- Small utilities and key-discovery helpers
vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.nvim" }, -- mini-universe dependency
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" }, -- which-key dependency
	{ src = "https://github.com/folke/which-key.nvim" },
})
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.notify").setup()
require("which-key").setup({
	spec = {
		-- After leader
		{ "<leader>t", group = "[T]oggle" },

		-- LSP
		{ "grn", desc = "Re[N]ame" },
		{ "grr", desc = "[R]eferences" },
		{ "gri", desc = "[I]mplementation" },
		{ "grt", desc = "[T]ype" },
		{ "grd", desc = "[D]efinition" },
	},
})
