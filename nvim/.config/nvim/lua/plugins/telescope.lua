return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-tree/nvim-web-devicons",
			"folke/trouble.nvim",
		},
		opts = function()
			local actions = require("telescope.actions")
			local trouble = require("trouble.sources.telescope")

			return {
				defaults = {
					hidden = true,
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							preview_width = 0.5,
						},
					},
					mappings = {
						n = {
							["<C-s>"] = actions.select_vertical,
							["<C-q>"] = trouble.open,
						},
						i = {
							["<C-s>"] = actions.select_vertical,
							["<C-q>"] = trouble.open,
						},
					},
				},
			}
		end,
		keys = {
			{
				"<leader>sh",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "[H]elp",
			},
			{
				"<leader>sk",
				function()
					require("telescope.builtin").keymaps()
				end,
				desc = "[K]eymaps",
			},
			{
				"<leader>sf",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "[F]iles",
			},
			{
				"<leader>ss",
				function()
					require("telescope.builtin").builtin()
				end,
				desc = "[S]earch",
			},
			{
				"<leader>sg",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "[G]rep",
			},
			{
				"<leader>sd",
				function()
					require("telescope.builtin").diagnostics()
				end,
				desc = "[D]iagnostics",
			},
			{
				"<leader>sn",
				function()
					require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "[N]eovim",
			},
			{
				"<leader>sw",
				function()
					require("telescope.builtin").lsp_dynamic_workspace_symbols()
				end,
				desc = "[W]orkspace",
			},
			{
				"<leader>sc",
				function()
					require("telescope.builtin").git_status()
				end,
				desc = "[C]hanges",
			},
			{
				"<leader>sc",
				function()
					require("util.git-hunks").git_hunks()
				end,
				desc = "[C]hanges",
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
