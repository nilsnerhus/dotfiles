vim.g.mapleader = " "

-- Load all plugins
vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-mini/mini.icons" }, -- do I really need two of these?
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" }, -- in this needed?
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" }, -- and this one?
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/folke/lazydev.nvim" }, -- and this one?
	{ src = "https://github.com/jmbuhr/cmp-pandoc-references" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/folke/todo-comments.nvim" },
	{ src = "https://github.com/folke/zen-mode.nvim" },
	{ src = "https://github.com/folke/noice.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/rcarriga/nvim-notify" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/anuvyklack/middleclass" },
	{ src = "https://github.com/anuvyklack/windows.nvim" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/epwalsh/obsidian.nvim" },
	{ src = "https://github.com/quarto-dev/quarto-nvim" },
	{ src = "https://github.com/jmbuhr/otter.nvim" },
	{ src = "https://github.com/benlubas/molten-nvim" },
}, { load = true })

-- Colorscheme
vim.cmd.colorscheme("tokyonight-day")

-- Treesitter
require("nvim-treesitter.config").setup({
	ensure_installed = {
		"bash",
		"c",
		"diff",
		"html",
		"lua",
		"luadoc",
		"markdown",
		"markdown_inline",
		"query",
		"r",
		"vim",
		"vimdoc",
		"yaml",
		"json",
	},
	auto_install = true,
})

-- Mason
require("mason").setup({})

require("mason-tool-installer").setup({
	ensure_installed = {
		"marksman",
		"rumdl",
		"r-languageserver",
		"air",
		"lua-language-server",
		"stylua",
		"ty",
		"ruff",
	},
})

-- FEAT: Understand blink
require("blink.cmp").setup({
	appearance = { nerd_font_variant = "mono" },
	completion = { documentation = { auto_show = true, auto_show_delay_ms = 100 } },
	sources = {
		default = { "lsp", "path", "lazydev", "references" },
		providers = {
			lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
			references = {
				name = "pandoc_references",
				module = "cmp-pandoc-references.blink",
				enabled = function()
					local ft = vim.bo.filetype
					return ft == "markdown" or ft == "quarto" or ft == "pandoc" or ft == "rmd" or ft == "typst"
				end,
			},
		},
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
	signature = { enabled = true },
})

-- FEAT: Understand lazydev, and if I actually need it
require("lazydev").setup({ library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } })

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
		{ "gd", desc = "[d]efinition" },
		{ "gD", desc = "[D]eclaration" },
	},
})

require("trouble").setup({
	focus = true,
	win = {
		position = "right",
		wo = {
			winfixwidth = false,
			winfixheight = false,
		},
	},
	modes = {
		quickfix = {
			sort = { "filename", "lnum", "col" },
		},
	},
})

require("todo-comments").setup({
	keywords = {
		TODO = { icon = "", color = "info", alt = { "FEAT" } },
		HACK = { icon = "", color = "warning", alt = { "CHORE" } },
		NOTE = { icon = "ℹ", color = "hint", alt = { "INFO" } },
	},
})

-- FEAT: Understand Zen mode
require("zen-mode").setup({
	window = {
		width = 80,
		height = 1,
		options = {
			signcolumn = "yes",
			number = true,
			relativenumber = true,
			cursorline = true,
			foldcolumn = "1",
			list = false,
		},
	},
	plugins = {
		options = { enabled = true, ruler = true, showcmd = true, laststatus = 3 },
		gitsigns = { enabled = true },
	},
})

require("noice").setup({
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
	views = {
		split = { enter = true, position = "right", win_options = { winfixwidth = false, winfixheight = false } },
		messages = { view = "split" },
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
		left_pad = 1,
		right_pad = 1,
	},
	link = {
		wiki = {
			enabled = true,
			icon = "󱗖 ",
		},
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
