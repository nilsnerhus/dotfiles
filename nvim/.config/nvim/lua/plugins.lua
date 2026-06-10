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

	-- Source file tools
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/folke/todo-comments.nvim" },

	-- Notebook
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/quarto-dev/quarto-nvim" },
	{ src = "https://github.com/jmbuhr/otter.nvim" },
	{ src = "https://github.com/Vigemus/iron.nvim" },

	-- Neovim
	{ src = "https://github.com/d00h/nvim-rusticated" },
	{ src = "https://github.com/folke/zen-mode.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },
})

vim.cmd.colorscheme("rusticated")

-- External services
require("tiny-inline-diagnostic").setup()
require("nvim-treesitter").setup({
	ensure_installed = {
		"bash",
		"html",
		"json",
		"latex",
		"lua",
		"markdown",
		"markdown_inline",
		"r",
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
		"r-languageserver",
		"marksman",
		"rumdl",
		"tinymist",
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
				opts = {
					global_files = { vim.fn.expand("~/library.bib") },
					filetypes = { "markdown", "typst", "quarto" },
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
		bibtex = { global_files = { vim.fn.expand("~/library.bib") } },
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

-- Source file tools
require("mini.git").setup()

-- Notebook
require("quarto").setup({
	codeRunner = { default_method = "iron" },
})
require("iron").setup({
	config = {
		scratch_repl = true,
		repl_definition = { r = { command = { "arf" } } },
		repl_open_cmd = require("iron.view").split.vertical.rightbelow(80),
	},
})
require("render-markdown").setup({
	file_types = { "markdown", "quarto" },
	heading = { position = "inline" },
	bullet = { right_pad = 1 },
	sign = { enabled = false },
})

-- Neovim
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.notify").setup()
require("zen-mode").setup({
	window = { backdrop = 1, width = 75 },
	plugins = { options = { gitsigns = { enabled = true } } },
})
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
