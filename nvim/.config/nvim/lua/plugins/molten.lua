return {
	"benlubas/molten-nvim",
	ft = { "python", "markdown", "quarto", "r" },
	keys = {
		{ "<leader>mi", "<cmd>MoltenInit<cr>", desc = "[I]nitialize" },
		{ "<leader>md", "<cmd>MoltenDeinit<cr>", desc = "[D]einitialize" },
		{ "<leader>mr", "<cmd>MoltenEvaluateCell<cr>", desc = "[R]un" },
		{ "<leader>mr", ":<C-u>MoltenEvaluateVisual<cr>gv", mode = "v", desc = "[R]un" },
		{ "<leader>mo", "<cmd>MoltenShowOutput<cr>", desc = "[O]pen" },
		{ "<leader>mc", "<cmd>MoltenHideOutput<cr>", desc = "[C]lose" },
		{ "<leader>me", "<cmd>MoltenEnterOutput<cr>", desc = "[E]nter" },
		{ "<leader>mx", "<cmd>MoltenInterrupt<cr>", desc = "[X] Cancel" },
	},
}
