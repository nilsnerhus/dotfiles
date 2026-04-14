-- R Language Server configuration

return {
	cmd = { "r-languageserver" },
	filetypes = { "r" },
	root_dir = function(bufnr, on_dir)
		on_dir(vim.fs.root(bufnr, ".git") or vim.uv.os_homedir())
	end,
}