-- LSP configuration

vim.lsp.enable({
	"marksman",
	"r-language_server",
	"lua_ls",
	"ty",
	"yamlls",
	"tinymist",
})

vim.diagnostic.config({
	severity_sort = true,
	virtual_text = true,
	signs = false,
})
