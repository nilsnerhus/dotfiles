return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {

				"markdown-oxide", -- Markdown/Quarto LSP
				"rumdl", -- Markdown formatter

				"r-languageserver", -- R LSP (for code blocks via Otter)
				"air", -- R formatter (from Posit)

				"lua-language-server", -- Lua LSP
				"stylua", -- Lua formatter
			},
		},
	},
}
