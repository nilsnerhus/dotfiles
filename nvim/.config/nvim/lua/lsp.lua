-- Plugins used by this module
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
})

-- --- Tiny diagnostics
-- Plugin that adds a non-intrusive way to view issues that the lsps find
vim.pack.add({ { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" } })
require("tiny-inline-diagnostic").setup()

local severity = vim.diagnostic.severity
vim.diagnostic.config({
	signs = {
		text = {
			[severity.ERROR] = "",
			[severity.WARN] = "",
			[severity.INFO] = "",
			[severity.HINT] = "",
		},
		numhl = {
			[severity.ERROR] = "DiagnosticSignError",
			[severity.WARN] = "DiagnosticSignWarn",
			[severity.INFO] = "DiagnosticSignInfo",
			[severity.HINT] = "DiagnosticSignHint",
		},
	},
})

-- --- Treesitter
-- Install parsers and enable highlighting wherever a parser is available.
require("nvim-treesitter").install({
	"bash",
	"csv",
	"go",
	"gomod",
	"html",
	"json",
	"latex",
	"lua",
	"markdown",
	"markdown_inline",
	"r",
	"rnoweb",
	"typst",
	"regex",
	"vim",
	"yaml",
})

-- --- Mason
-- Package manager plugin that installs the language servers and formatters
require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua-language-server", -- lua LSP
		"gopls", -- go LSP
		"rumdl", -- markdown LSP
		"superhtml", -- html LSP
		"tinymist", -- typst LSP

		"air",   -- r formatter
		"shfmt", -- bash formatter
		"yamlfmt", -- yaml formatter
	},
})
-- --- Conform
-- Formatter plugin that runs the formatters installed above
require("conform").setup({
	format_on_save = {
		lsp_format = "fallback", -- most formatters are built-ins
	},
	formatters_by_ft = {
		r = { "air" },
		sh = { "shfmt" },
		yaml = { "yamlfmt" },
	},
})

-- --- vim.lsp
-- Builtin system to configure and enable the language servers installed above
vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".git" },                               -- defines where the lsp stops searching
	settings = { Lua = { diagnostics = { globals = { "vim" } } } }, -- makes the lsp ignore the vim.-functions
})
vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod" },
	root_markers = { ".git" },
})
vim.lsp.config("rumdl", {
	cmd = { "rumdl", "server" },
	filetypes = { "markdown", "quarto" },
	root_markers = { ".git" },
})
vim.lsp.config("superhtml", {
	cmd = { "superhtml", "lsp" },
	filetypes = { "html" },
	root_markers = { ".git" },
})
vim.lsp.config("tinymist", {
	cmd = { "tinymist" },
	filetypes = { "typst" },
	root_markers = { ".git" },
})

vim.lsp.enable({
	"lua_ls",
	"gopls",
	"rumdl",
	"superhtml",
	"tinymist",
})

-- LSP keymap for navigating to definition, mostly used to follow Markdown links
vim.keymap.set("n", "grd", vim.lsp.buf.definition, { desc = "[d]efinition" })
