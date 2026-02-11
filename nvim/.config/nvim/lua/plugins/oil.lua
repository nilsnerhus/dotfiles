-- FIX: Add a keymap
-- FIX: Add some way of toggling hidden files on and off
-- FIX: Add some way of moving up and fown the direcotry, or just better understand the keymaps. ctrl+o doesn't always cut it
return {
	"stevearc/oil.nvim",
	dependencies = {
		"nvim-mini/mini.icons",
	},
	opts = {
		win_options = {
			wrap = true,
			signcolumn = "yes",
		},
		delete_to_trash = false,
	},
	lazy = false,
}
