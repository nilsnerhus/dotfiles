return {
	"folke/zen-mode.nvim",
	opts = {
		window = {
			backdrop = 1, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
			width = 80, -- width of the Zen window
			height = 1, -- height of the Zen window
			options = {
				signcolumn = "yes", -- display signcolumn
				number = true, -- display number
				relativenumber = true, -- display relative number
				cursorline = true, -- display cursorline
				cursorcolumn = false, -- disable cursor column
				foldcolumn = "1", -- disable fold column
				list = false, -- disable whitespace characters
			},
		},
		plugins = {
			options = {
				enabled = true,
				ruler = true,
				showcmd = true,
				laststatus = 3,
			},
			gitsigns = { enabled = true }, -- enables git signs
		},
	},
	keys = {
		{ "<leader>tz", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
	},
}
