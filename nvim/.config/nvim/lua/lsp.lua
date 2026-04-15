vim.lsp.enable({
	"marksman",
	"r-languageserver",
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
