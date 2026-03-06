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

			local function toggle_preview()
				if vim.g.quarto_preview_active then
					vim.cmd("QuartoClosePreview")
					vim.g.quarto_preview_active = false
				else
					vim.cmd("QuartoPreview")
					vim.g.quarto_preview_active = true
				end
			end

			vim.keymap.set("n", "<leader>tq", toggle_preview, { desc = "[T]oggle [Q]uarto" })
		end,
	},
}
