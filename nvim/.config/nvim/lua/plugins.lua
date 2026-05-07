-- Load all plugins
vim.pack.add({
	-- Dependencies
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" }, -- just for cmp-pandoc-references
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-mini/mini.nvim" },

	-- External services
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
	{ src = "https://github.com/Saghen/blink.cmp", version = "v1.10.2" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },

	-- File navigation
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },

	-- Souce file tools
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/folke/todo-comments.nvim" },

	-- Notebook
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/quarto-dev/quarto-nvim" },
	{ src = "https://github.com/jmbuhr/otter.nvim" },
	{ src = "https://github.com/jmbuhr/cmp-pandoc-references" },

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
require("mason").setup({})
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
		per_filetype = {
			markdown = { "lsp", "pandoc_references" },
			quarto = { "lsp", "pandoc_references" },
		},
		providers = {
			pandoc_references = {
				name = "pandoc_references",
				module = "cmp-pandoc-references.blink",
			},
		},
	},
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 500,
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

-- Source file tools
require("mini.git").setup()
require("todo-comments").setup({
	signs = false,
	keywords = {
		TODO = { icon = "", color = "info", alt = { "FEAT" } },
		HACK = { icon = "", color = "warning", alt = { "CHORE" } },
		NOTE = { icon = "ℹ", color = "hint", alt = { "INFO" } },
	},
})

-- Notebook
require("quarto").setup()
require("render-markdown").setup({
	file_types = { "markdown", "quarto" },
	quote = { repeat_linebreak = true },
	heading = { position = "inline" },
	bullet = { right_pad = 1 },
	sign = { enabled = false },
	html = { comment = { conceal = false } },
	latex = { enabled = false },
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
