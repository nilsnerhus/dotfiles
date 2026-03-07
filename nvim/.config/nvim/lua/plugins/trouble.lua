return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		focus = true,
		win = {
			position = "right",
			wo = {
				winfixwidth = false,
				winfixheight = false,
			},
		},
		modes = {
			quickfix = {
				sort = { "filename", "lnum", "col" },
			},
		},
	},
	keys = {
		{
			"]t",
			function()
				require("trouble").next({ jump = true })
			end,
			desc = "Next trouble item",
		},
		{
			"]T",
			function()
				require("trouble").last({ jump = true })
			end,
			desc = "Last trouble item",
		},
		{
			"[t",
			function()
				require("trouble").prev({ jump = true })
			end,
			desc = "Previous trouble item",
		},
		{
			"[T",
			function()
				require("trouble").first({ jump = true })
			end,
			desc = "First trouble item",
		},
	},
}
