-- FEAT: Research the possibility of using more of either the mini or the snacks ecosystem
-- FIX: File an issue, and possibly a pull request, to change cmp-pandoc-references to not use nvim-lspconfig

-- Load all plugins
vim.pack.add({
	-- Main dependencies
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-mini/mini.icons" },
	{ src = "https://github.com/d00h/nvim-rusticated" },
	{ src = "https://github.com/typicode/bg.nvim" },

	-- Code intellisense
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/saghen/blink.cmp" },

	-- Navigation
	{ src = "https://github.com/nvim-telescope/telescope.nvim" }, -- mini.pick/snacks.picker
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/folke/zen-mode.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },

	-- Visuals
	{ src = "https://github.com/folke/noice.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/rcarriga/nvim-notify" },
	{ src = "https://github.com/anuvyklack/middleclass" },
	{ src = "https://github.com/anuvyklack/windows.nvim" }, -- mini.animate/snacks.win
	{ src = "https://github.com/folke/which-key.nvim" }, -- mini.clue/snacks.toggle
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/folke/todo-comments.nvim" },

	-- Git
	{ src = "https://github.com/lewis6991/gitsigns.nvim" }, -- mini.diff
	{ src = "https://github.com/tpope/vim-fugitive" },

	-- Writing
	{ src = "https://github.com/windwp/nvim-autopairs" },

	-- Notes
	-- { src = "https://github.com/jmbuhr/cmp-pandoc-references" }, -- incompatible for now
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/epwalsh/obsidian.nvim" },
	{ src = "https://github.com/quarto-dev/quarto-nvim" },
	{ src = "https://github.com/jmbuhr/otter.nvim" },
	{ src = "https://github.com/benlubas/molten-nvim" },
})

vim.cmd.colorscheme("rusticated")

require("mason").setup({})
require("nvim-autopairs").setup({})
require("nvim-treesitter").setup({ auto_install = true })
require("blink.cmp").setup({})
require("trouble").setup({ win = { position = "right" } })
require("zen-mode").setup({ window = { width = 80 } })

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

-- UI
require("which-key").setup({
	delay = 10,
	icons = { mappings = vim.g.have_nerd_font, keys = vim.g.have_nerd_font and {} or nil },
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

require("noice").setup({})

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

require("oil").setup({})

require("obsidian").setup({
	workspaces = {
		{ name = "tunet", path = "~/prosjekter/tunet" },
		{ name = "fjøset", path = "~/prosjekter/fjøset" },
	},
	preferred_link_style = "wiki",
	completion = { nvim_cmp = false, min_chars = 2 },
	disable_frontmatter = true,
	mappings = {},
	ui = { enable = false },
})

require("quarto").setup({
	closePreviewOnExit = true,
	lspFeatures = { chunks = "curly", languages = { "r", "python" }, diagnostics = { enabled = true } },
	codeRunner = { enabled = true, default_method = "molten", never_run = { "yaml" } },
})

-- System
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
vim.ui.open = function(url)
	vim.fn.system({ "wsl-open", url })
end
