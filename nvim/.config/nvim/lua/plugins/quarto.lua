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
				default_method = "molten",
				never_run = { "yaml" },
			},
		},
		config = function(_, opts)
			require("quarto").setup(opts)
			-- Note: Code runner keymaps are handled by molten live preview mode (<leader>tm)
		end,
	},
}
