return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			defaults = { hidden = true },
			pickers = {
				find_files = {
					mappings = {
						n = {
							["<C-s>"] = require("telescope.actions").select_vertical,
							["<C-q>"] = require("telescope.actions").send_to_qflist,
						},
					},
				},
			},
		},
		keys = {
			{
				"<leader>sh",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "[S]earch [H]elp",
			},
			{
				"<leader>sk",
				function()
					require("telescope.builtin").keymaps()
				end,
				desc = "[S]earch [K]eymaps",
			},
			{
				"<leader>sf",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "[S]earch [F]iles",
			},
			{
				"<leader>ss",
				function()
					require("telescope.builtin").builtin()
				end,
				desc = "[S]earch [S]earch",
			},
			{
				"<leader>sg",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "[S]earch by [G]rep",
			},
			{
				"<leader>sd",
				function()
					require("telescope.builtin").diagnostics()
				end,
				desc = "[S]earch [D]iagnostics",
			},
			{
				"<leader>sn",
				function()
					require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "[S]earch [N]eovim",
			},
			{
				"<leader>sw",
				function()
					require("telescope.builtin").lsp_dynamic_workspace_symbols()
				end,
				desc = "[S]earch [W]orkspace",
			},
			{ "<leader>st", ":TodoTelescope<CR>", desc = "[S]earch [T]odos" },
			{
				"<leader>gs",
				function()
					require("telescope.builtin").git_status()
				end,
				desc = "[G]it [S]tatus",
			},
		},
		config = function(_, opts)
			require("telescope").setup(opts)
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- Enable line wrapping in previewer
			vim.api.nvim_create_autocmd("User", {
				pattern = "TelescopePreviewerLoaded",
				callback = function()
					vim.wo.wrap = true
				end,
			})
		end,
	},
}
