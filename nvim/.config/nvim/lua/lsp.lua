-- LSP configuration

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

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		if vim.bo[ev.buf].filetype == "markdown" or vim.bo[ev.buf].filetype == "quarto" then
			return
		end
		vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = true })
	end,
})
