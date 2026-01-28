return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			notify_on_error = true,
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
				quarto = { "injected", "rumdl" },
			},
		},
	},
}
