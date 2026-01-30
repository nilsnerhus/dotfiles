-- Quarto integration for Neovim
-- Provides preview, code running, and LSP features for Quarto documents
--
-- Custom behavior:
-- - <leader>tq toggles Quarto preview (runs hidden, no terminal tab)
-- - First press starts preview, second press stops it

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
	},
}
