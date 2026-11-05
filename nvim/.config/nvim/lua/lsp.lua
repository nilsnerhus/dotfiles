-- --- Treesitter
-- Install all treesitters for all file types that I might run into
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
		"rnoweb",
		"typst",
		"utftex",
		"regex",
		"vim",
		"yaml",
	},
})

-- --- Mason
-- Package manager plugin that installs the language servers and formatters
require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua-language-server", -- Lua LSP
		"stylua", -- Lua formatter
		"air", -- r formatter
		"marksman", -- markdown lsp
		"rumdl", -- markdown formatter
		"yamlfmt", -- yaml formatter
		"shfmt", -- bash formatter
	},
})
-- --- Conform
-- Formatter plugin that runs the formatters installed above
require("conform").setup({
	format_on_save = {
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		lua = { "stylua" },
		sh = { "shfmt" },
		quarto = { "rumdl" },
		yaml = { "yamlfmt" },
		markdown = { "rumdl" },
		r = { "air" },
	},
})

-- --- Language servers
-- Builting lsp.config to configure the language servers I have, and then lsp.enable to enable them
vim.lsp.config("marksman", {
	cmd = { "marksman" },
	filetypes = { "markdown", "quarto" },
	root_markers = { ".git" },
})
vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".git" }, -- defines where the lsp stops searching
	settings = { Lua = { diagnostics = { globals = { "vim" } } } }, -- makes the lsp ignore the vim.-functions
})
vim.lsp.enable({
	"marksman",
	"lua_ls",
})
