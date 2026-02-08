-- FIX: Add a keybind to toggle Quarto Preview on and off, and make sure it stay on the original file that is previewed.
return {
	{
		"quarto-dev/quarto-nvim",
		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			closePreviewOnExit = true,
			lspFeatures = {
				chunks = "curly",
				languages = { "r", "python" },
				diagnostics = { enabled = true },
			},
			codeRunner = {
				enabled = true,
				default_method = "iron",
				never_run = { "yaml" },
			},
		},
		config = function(_, opts)
			require("quarto").setup(opts)

			-- Quarto-specific keybindings for code runner
			local runner = require("quarto.runner")
			vim.keymap.set("n", "<leader>rc", runner.run_cell, { desc = "run cell", silent = true })
			vim.keymap.set("n", "<leader>ra", runner.run_above, { desc = "run cell and above", silent = true })
			vim.keymap.set("n", "<leader>rA", runner.run_all, { desc = "run all cells", silent = true })
			vim.keymap.set("n", "<leader>rl", runner.run_line, { desc = "run line", silent = true })
			vim.keymap.set("v", "<leader>r", runner.run_range, { desc = "run visual range", silent = true })
		end,
	},
}
