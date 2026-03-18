-- LSP configuration

vim.lsp.enable({
	"marksman",
	"r_language_server",
	"lua_ls",
	"ty",
})

-- FEAT: Understand how this impacts the messages I am seeing, and how I can change them
vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	signs = vim.g.have_nerd_font and {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
	} or {},
	virtual_text = {
		source = "if_many",
		spacing = 2,
		format = function(d)
			return d.message
		end,
	},
})
