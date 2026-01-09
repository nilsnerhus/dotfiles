return {
	{
		"quarto-dev/quarto-nvim",
		dependencies = { "jmbuhr/otter.nvim", "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("quarto").setup({
				debug = false,
				closePreviewOnExit = true,
				lspFeatures = {
					enabled = false,
					chunks = "curly",
					languages = { "r" },
					diagnostics = { enabled = true, triggers = { "BufWritePost" } },
					completion = { enabled = true },
				},
				codeRunner = { enabled = true, default_method = "iron", never_run = { "yaml" } },
			})
		end,
	},
}
