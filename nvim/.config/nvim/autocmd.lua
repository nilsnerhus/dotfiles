-- Enable spell checking for text/markup files
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "markdown", "text", "gitcommit", "tex", "latex", "quarto" },
	callback = function()
		vim.opt_local.spell = true
	end,
})
