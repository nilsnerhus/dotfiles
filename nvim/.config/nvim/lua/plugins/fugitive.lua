return {
	"tpope/vim-fugitive",
	config = function()
		-- Make git commit open as vsplit
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "gitcommit",
			callback = function()
				vim.cmd("wincmd L")
			end,
		})
	end,
}
