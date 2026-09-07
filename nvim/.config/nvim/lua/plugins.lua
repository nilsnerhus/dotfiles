-- Load all plugins
vim.pack.add({
	-- Dependencies
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-mini/mini.nvim" },

	-- External services
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
	{ src = "https://github.com/Saghen/blink.cmp", version = "v1.10.2" },
	{ src = "https://github.com/krissen/blink-cmp-bibtex" },

	-- File navigation
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-bibtex.nvim" },

	-- Notebook
	{ src = "https://github.com/hat0uma/csvview.nvim" },
	{ src = "https://github.com/R-nvim/R.nvim" },

	-- Neovim
	{ src = "https://github.com/d00h/nvim-rusticated" },
	{ src = "https://github.com/folke/which-key.nvim" },
})

vim.cmd.colorscheme("rusticated")

-- Highlight overrides
vim.api.nvim_set_hl(0, "CsvViewHeaderLine", { bold = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.api.nvim_set_hl(0, "CsvViewHeaderLine", { bold = true })
	end,
})

-- External services
require("tiny-inline-diagnostic").setup()
require("nvim-treesitter").setup({
	ensure_installed = {
		"bash",
		"csv",
		"html",
		"json",
		"latex",
		"lua",
		"markdown",
		"markdown_inline",
		"r",
		"csv",
		"rnoweb",
		"typst",
		"utftex",
		"regex",
		"vim",
		"yaml",
	},
})
require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"stylua",
		"lua-language-server",
		"air",
		"marksman",
		"rumdl",
		"yaml-language-server",
	},
})
require("conform").setup({
	format_on_save = { enabled = true },
	formatters_by_ft = {
		lua = { "stylua" },
		r = { "air" },
		markdown = { "rumdl" },
		quarto = { "rumdl", "injected" },
		yaml = { lsp_format = "fallback" },
		typst = { lsp_format = "fallback" },
	},
	formatters = { injected = { options = { lang_to_formatters = { r = { "air" } } } } },
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

-- File navigation
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
require("telescope").load_extension("bibtex")

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

-- Notebook
require("csvview").setup({
	view = { display_mode = "border" },
})
require("r").setup({
	user_maps_only = true,
	disable_cmds = { "RInsertPipe", "RInsertAssign", "RmdInsertChunk" },
})

-- Neovim
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.notify").setup()
require("which-key").setup({
	spec = {
		-- After leader
		{ "<leader>s", group = "[S]earch" },
		{ "<leader>t", group = "[T]oggle" },
		{ "<leader>g", group = "[G]it" },
		{ "<leader>n", group = "[N]ote" },
		{ "<leader>r", group = "[R]un" },
		{ "<leader>z", group = "[Z]pell" },

		-- LSP
		{ "gr", group = "[R]eference" },
		{ "gra", desc = "Code [A]ction" },
		{ "grn", desc = "Re[N]ame" },
		{ "grr", desc = "[R]eferences" },
		{ "gri", desc = "[I]mplementation" },
		{ "grt", desc = "[T]ype" },
		{ "grd", desc = "[d]efinition" },
		{ "grD", desc = "[D]eclaration" },
	},
})
