-- Load all plugins
vim.pack.add({
	-- Dependencies
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-mini/mini.icons" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },

	-- External services
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },

	-- File navigation
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },

	-- Souce file tools
	{ src = "https://github.com/lewis6991/gitsigns.nvim" }, -- mini.diff?
	{ src = "https://github.com/tpope/vim-fugitive" }, -- mini.git?
	{ src = "https://github.com/folke/todo-comments.nvim" },

	-- Notebook
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/quarto-dev/quarto-nvim" },
	{ src = "https://github.com/jmbuhr/otter.nvim" },

	-- Etc.
	{ src = "https://github.com/d00h/nvim-rusticated" },
	{ src = "https://github.com/folke/zen-mode.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" }, -- mini.clue?
	{ src = "https://github.com/windwp/nvim-autopairs" }, --mini.pairs?
	{ src = "https://github.com/rcarriga/nvim-notify" }, -- mini.notify
})

-- External services
require("nvim-treesitter").setup({})
require("mason").setup({})
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


require("todo-comments").setup({
	signs = false,
	keywords = {
		TODO = { icon = "", color = "info", alt = { "FEAT" } },
		HACK = { icon = "", color = "warning", alt = { "CHORE" } },
		NOTE = { icon = "ℹ", color = "hint", alt = { "INFO" } },
	},
})

-- Notebook
require("quarto").setup({})
require("render-markdown").setup({
	file_types = { "markdown", "quarto" },
	quote = { repeat_linebreak = true },
	heading = { position = "inline" },
	bullet = { right_pad = 1 },
	sign = { enabled = false },
	html = { comment = { conceal = false } },
})

-- Etc
require("nvim-autopairs").setup({})
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

-- System
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. os.getenv("HOME") .. "/.local/bin:" .. vim.env.PATH
vim.ui.open = function(url)
	vim.fn.system({ "wsl-open", url })
end

-- Platform-specific configuration
do
	local is_wsl = vim.fn.has("wsl") == 1

	if is_wsl then
		vim.ui.open = function(url)
			vim.fn.system({ "wsl-open", url })
		end
	end
end
