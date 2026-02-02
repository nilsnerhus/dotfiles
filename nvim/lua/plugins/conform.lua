return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			python = { "ruff" },
			format_on_save = function(bufnr)
				return {
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				r = { "air" },
				markdown = { "rumdl" },
				quarto = { "rumdl", "injected" },
			},
		},
	},
}
