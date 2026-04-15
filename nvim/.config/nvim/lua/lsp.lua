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
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method("textDocument/completion") then
			-- Trigger completion on every printable ASCII character
			local chars = {}
			for i = 32, 126 do
				table.insert(chars, string.char(i))
			end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
