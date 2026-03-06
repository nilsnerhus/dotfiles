return {
	"stevearc/oil.nvim",
	dependencies = {
		"nvim-mini/mini.icons",
	},
	opts = {
		win_options = {
			wrap = true,
			signcolumn = "yes",
		},
		delete_to_trash = false,
	},
	lazy = false,
	keys = {
		{
			"-",
			function()
				require("oil").open()
			end,
			desc = "Open parent directory",
		},
	},
}
