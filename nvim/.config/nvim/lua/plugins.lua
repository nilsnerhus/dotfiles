-- FEAT: Research the possibility of using more of either the mini or the snacks ecosystem
-- FIX: File an issue, and possibly a pull request, to change cmp-pandoc-references to not use nvim-lspconfig

-- Load all plugins
vim.pack.add({
	-- Main dependencies
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-mini/mini.icons" },
	{ src = "https://github.com/d00h/nvim-rusticated" },

	-- Code intellisense
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },

	-- Visuals
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/folke/todo-comments.nvim" },
	{ src = "https://github.com/folke/noice.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" }, -- noice dep

	-- Notes
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/quarto-dev/quarto-nvim" },
	{ src = "https://github.com/jmbuhr/otter.nvim" },
	{ src = "https://github.com/benlubas/molten-nvim" },

	-- FIX: Replace this list with the mini alternatives
	{ src = "https://github.com/stevearc/oil.nvim" }, -- mini.files?
	{ src = "https://github.com/folke/which-key.nvim" }, -- mini.clue?
	{ src = "https://github.com/lewis6991/gitsigns.nvim" }, -- mini.diff?
	{ src = "https://github.com/tpope/vim-fugitive" }, -- mini.git?
	{ src = "https://github.com/windwp/nvim-autopairs" }, --mini.pairs?
	{ src = "https://github.com/rcarriga/nvim-notify" }, -- mini.notify
	{ src = "https://github.com/anuvyklack/middleclass" }, -- windows dep
	{ src = "https://github.com/anuvyklack/windows.nvim" }, -- should be removed as I understand how to better configure layouts
	{ src = "https://github.com/folke/zen-mode.nvim" }, -- might not be needed
})

vim.cmd.colorscheme("rusticated")

require("mason").setup({})
require("oil").setup({})
require("nvim-autopairs").setup({})
require("nvim-treesitter").setup({})
require("noice").setup({})

require("trouble").setup({
	win = { position = "right" },
})
require("zen-mode").setup({
	window = { width = 80 },
})

require("quarto").setup({
	codeRunner = { default_method = "molten" },
})

-- Telescope
local ok_actions, actions = pcall(require, "telescope.actions")
local ok_trouble, trouble = pcall(require, "trouble.sources.telescope")

require("telescope").setup({
	defaults = {
		hidden = true,
		layout_strategy = "horizontal",
		layout_config = { horizontal = { preview_width = 0.5 } },
		mappings = {
			n = {
				["<C-s>"] = ok_actions and actions.select_vertical or nil,
				["<C-q>"] = ok_trouble and trouble.open or nil,
			},
			i = {
				["<C-s>"] = ok_actions and actions.select_vertical or nil,
				["<C-q>"] = ok_trouble and trouble.open or nil,
			},
		},
	},
})

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

vim.api.nvim_create_autocmd("User", {
	pattern = "TelescopePreviewerLoaded",
	callback = function()
		vim.wo.wrap = true
	end,
})

require("blink.cmp").setup({
	sources = {
		per_filetype = {
			quarto = { "lsp", "path", "snippets" },
		},
	},
})

-- UI
require("which-key").setup({
	spec = {
		-- After leader
		{ "<leader>s", group = "[S]earch" },
		{ "<leader>t", group = "[T]oggle" },
		{ "<leader>g", group = "[G]it" },
		{ "<leader>m", group = "[M]olten" },
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

require("todo-comments").setup({
	keywords = {
		TODO = { icon = "", color = "info", alt = { "FEAT" } },
		HACK = { icon = "", color = "warning", alt = { "CHORE" } },
		NOTE = { icon = "ℹ", color = "hint", alt = { "INFO" } },
	},
})

-- Window management
require("windows").setup({
	autowidth = {
		enable = true,
		winwidth = 0,
	},
})

-- Formatting
require("conform").setup({
	format_on_save = function(bufnr)
		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
	formatters_by_ft = {
		lua = { "stylua" },
		r = { "air" },
		markdown = { "rumdl" },
		quarto = { "rumdl", "injected" },
		python = { "ruff" },
	},
})

-- Markdown
require("render-markdown").setup({
	file_types = { "markdown", "quarto" },
	quote = { repeat_linebreak = true },
	heading = {
		position = "inline",
	},
	bullet = {
		right_pad = 1,
	},
})

-- System
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
vim.ui.open = function(url)
	vim.fn.system({ "wsl-open", url })
end
