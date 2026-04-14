-- Load all plugins
vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-mini/mini.icons" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/d00h/nvim-rusticated" },

	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },

	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },

	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/folke/todo-comments.nvim" },
	{ src = "https://github.com/folke/noice.nvim" },
	{ src = "https://github.com/folke/edgy.nvim" },
	{ src = "https://github.com/folke/zen-mode.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" }, -- noice dep

	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/quarto-dev/quarto-nvim" },
	{ src = "https://github.com/jmbuhr/otter.nvim" },
	{ src = "https://github.com/benlubas/molten-nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" }, -- dep for cmp-pandoc-references
	{ src = "https://github.com/jmbuhr/cmp-pandoc-references" },

	{ src = "https://github.com/folke/which-key.nvim" }, -- mini.clue?
	{ src = "https://github.com/lewis6991/gitsigns.nvim" }, -- mini.diff?
	{ src = "https://github.com/tpope/vim-fugitive" }, -- mini.git?
	{ src = "https://github.com/windwp/nvim-autopairs" }, --mini.pairs?
	{ src = "https://github.com/rcarriga/nvim-notify" }, -- mini.notify
})

vim.cmd.colorscheme("rusticated")

require("nvim-treesitter").setup({})
require("mason").setup({})
require("nvim-autopairs").setup({})
require("quarto").setup({})

require("oil").setup({
	use_default_keymaps = false,
	keymaps = {
		["<CR>"] = "actions.select",
		["-"] = "actions.parent",
		["<C-s>"] = { "actions.select", opts = { vertical = true } },
		["<C-r>"] = "actions.refresh",
		["g."] = "actions.toggle_hidden",
		["g?"] = { "actions.show_help", mode = "n" },
	},
})

require("zen-mode").setup({
	window = {
		backdrop = 1,
		width = 75,
	},
	plugins = {
		options = {
			gitsigns = { enabled = true },
		},
	},
})

require("trouble").setup({
	defaults = {
		auto_preview = { enabled = false },
	},
})

require("noice").setup({
	views = {
		messages = {
			view = "vsplit",
			size = { width = 60 },
		},
	},
})

require("edgy").setup({
	animate = {
		enabled = false,
	},
	right = {
		{ ft = "help", size = { width = 80 } },
		{ ft = "trouble" },
	},
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

-- UI
require("which-key").setup({
	spec = {
		-- After leader
		{ "<leader>s", group = "[S]earch" },
		{ "<leader>t", group = "[T]oggle" },
		{ "<leader>g", group = "[G]it" },
		{ "<leader>m", group = "[M]olten" },
		{ "<leader>n", group = "[N]ote" },
		{ "<leader>z", group = "[Z]pell" },
		{ "<leader>9", group = "[9]9 AI" },

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
	signs = false,
	keywords = {
		TODO = { icon = "", color = "info", alt = { "FEAT" } },
		HACK = { icon = "", color = "warning", alt = { "CHORE" } },
		NOTE = { icon = "ℹ", color = "hint", alt = { "INFO" } },
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
		yaml = { lsp_format = "fallback" },
		typst = { lsp_format = "fallback" },
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
	sign = {
		enabled = false,
	},
})

require("blink.cmp").setup({
	fuzzy = { implementation = "lua" },
	sources = {
		per_filetype = {
			quarto = { "lsp", "path", "snippets", "pandoc_references" },
			markdown = { "lsp", "path", "snippets", "pandoc_references" },
		},
		providers = {
			pandoc_references = {
				name = "pandoc_references",
				module = "cmp-pandoc-references.blink",
			},
		},
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
