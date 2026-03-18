-- Pyright LSP configuration
-- Python language server

return {
	cmd = { "ty", "--stdio" },
	filetypes = { "python" },
	root_markers = { ".git" },
}
