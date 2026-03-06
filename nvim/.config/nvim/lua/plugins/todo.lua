return {
	"folke/todo-comments.nvim",
	event = "BufReadPost",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		keywords = {
			TODO = { icon = " ", color = "info", alt = { "FEAT" } },
			HACK = { icon = " ", color = "warning", alt = { "CHORE" } },
			NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
		},
	},
}
