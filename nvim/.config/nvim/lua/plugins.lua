-- Load all plugins
vim.pack.add({
	-- Dependencies
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-mini/mini.nvim" },

	-- External services
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },

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

	-- Neovim
	{ src = "https://github.com/d00h/nvim-rusticated" },
	{ src = "https://github.com/folke/zen-mode.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },
})

-- Dependencies
require("mini.icons").setup()

-- External services
require("nvim-treesitter").setup()
require("mason").setup()
require("conform").setup({
	format_on_save = { enabled = true },
	formatters_by_ft = {
		lua = { "stylua" },
		r = { "air" },
		markdown = { "rumdl" },
		quarto = { "rumdl", "injected" },
		python = { "ruff" },
		yaml = { lsp_format = "fallback" },
		typst = { lsp_format = "fallback" },
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
})

-- Neovim
require("mini.pairs").setup()
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
