-- Mason: Package manager for LSP servers, formatters, linters
-- Single source of truth for all tool installations
-- Run :Mason to see installed tools and manage them manually

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
				-- LSP Servers
				"markdown-oxide",      -- Markdown/Quarto LSP
				"r-languageserver",    -- R LSP (for code blocks via Otter)
				"lua-language-server", -- Lua LSP

				-- Formatters
				"rumdl",  -- Markdown formatter
				"air",    -- R formatter (from Posit)
				"stylua", -- Lua formatter
			},
		},
	},
}
