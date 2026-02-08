-- FIX: Make the `gcc`-command work in quarto with frontmatter files when writing markdown, now it outputs `#` like a yaml comment
-- FIX: Make the todo-highlight stay on just the line with the note, and not bleed down
-- FIX: Make :TodoTelescope always show all tasks in the current dir
return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		keywords = {
			TODO = { icon = " ", color = "info", alt = { "FEAT" } },
			HACK = { icon = " ", color = "warning", alt = { "CHORE" } },
			NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
		},
	},
}
