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
		use_diagnostic_signs = true,
		modes = {
			quickfix = {
				auto_open = true,
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
			"[t",
			function()
				require("trouble").prev({ jump = true })
			end,
			desc = "Previous trouble item",
		},
		{
			"]T",
			function()
				require("trouble").first({ jump = true })
			end,
			desc = "First trouble item",
		},
		{
			"[T",
			function()
				require("trouble").last({ jump = true })
			end,
			desc = "Last trouble item",
		},
	},
}
