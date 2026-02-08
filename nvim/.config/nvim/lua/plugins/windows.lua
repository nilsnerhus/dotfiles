-- Andy's Mode style window management
-- Focused window is always 80 chars, unfocused windows shrink to fit
-- Smooth animations on focus change
return {
	"anuvyklack/windows.nvim",
	dependencies = {
		"anuvyklack/middleclass",
		"anuvyklack/animation.nvim",
	},
	config = function()
		-- Neovim settings for window size
		vim.o.winwidth = 10
		vim.o.winminwidth = 10
		vim.o.equalalways = false

		require("windows").setup({
			autowidth = {
				enable = true,
				winwidth = 0, -- 0 means textwidth + 0 (so 80 chars)
			},
			animation = {
				enable = true,
				duration = 100,
			},
		})
	end,
}
