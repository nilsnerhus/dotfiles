-- LSP configuration

vim.lsp.enable({
	"marksman",
	"r_language_server",
	"lua_ls",
	"ty",
})

vim.diagnostic.config({
	severity_sort = true,
	virtual_text = true,
	signs = false,
	jump = { float = true },
})
