-- Treesitter
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

-- Mason
require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"stylua", -- lua lsp
		"lua-language-server", -- lua formatter

		"air", -- r formatter

		"marksman", -- markdown lsp
		"rumdl", -- markdown formatter

		"yamlfmt", -- yaml formatter

		"shfmt", -- bash formatter
	},
})
require("conform").setup({
	format_on_save = { enabled = true },
	formatters_by_ft = {
		lua = { "stylua" },
		r = { "air" },
		markdown = { "rumdl" },
		quarto = { "rumdl", "injected" },
		yaml = { "yamlfmt" },
		sh = { "shfmt" },
	},
	formatters = { injected = { options = { lang_to_formatters = { r = { "air" } } } } },
})

-- LSP-config
vim.lsp.config("marksman", {
	cmd = { "marksman" },
	filetypes = { "markdown", "quarto" },
	root_markers = { ".git" },
})
vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".git" },
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})
vim.lsp.enable({
	"marksman",
	"lua_ls",
	"shellcheck",
})

vim.diagnostic.config({
	severity_sort = true,
	signs = true,
})
