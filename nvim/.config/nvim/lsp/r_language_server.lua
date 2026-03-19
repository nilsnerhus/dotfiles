-- R Language Server configuration

local r_lib = vim.fn.expand("~/R/x86_64-pc-linux-gnu-library/4.5")

return {
	cmd = {
		"sh",
		"-c",
		"R --no-echo -e '.libPaths(c(\"" .. r_lib .. "\", .libPaths())); languageserver::run()'",
	},
	filetypes = { "r" },
	root_markers = { ".git" },
}
