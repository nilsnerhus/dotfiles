-- Marksman LSP configuration
-- Markdown and Quarto language server

return {
	cmd = { "marksman", "server" },
	filetypes = { "markdown", "quarto" },
	root_markers = { ".git" },
}
