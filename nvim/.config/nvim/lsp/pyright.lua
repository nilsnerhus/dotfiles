-- Pyright LSP configuration
-- Python language server

return {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = { ".git" },
}
