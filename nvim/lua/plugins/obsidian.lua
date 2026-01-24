-- obsidian.lua - Note-taking with wiki-links, backlinks, and completion
-- Community fork (obsidian-nvim) with blink.cmp support
--
-- Features:
--   - Inline completion: type [[ and suggestions appear
--   - Link following: gf or <CR> on wiki-links
--   - Backlinks: :Obsidian backlinks
--   - Search: :Obsidian search
--   - Quick switch: :Obsidian quick_switch
--
-- Default keymaps (set automatically by obsidian.nvim):
--   <CR>  - smart_action (follow link, toggle checkbox, or cycle fold)
--   gf    - follow link under cursor
--   ]o    - next link in buffer
--   [o    - previous link in buffer
--
-- See :Obsidian help for documentation

return {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- Use latest release
	ft = { "markdown", "quarto" },
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "notater",
				path = "~/prosjekter/notater/src",
			},
		},

		-- Completion: use blink.compat to bridge nvim-cmp source to blink.cmp
		-- This was working to find files with [[ trigger
		completion = {
			blink = true,
			min_chars = 2,
		},

		-- Wiki link format: [[filename|Title]]
		wiki_link_func = "prepend_note_id",

		-- Picker for commands like :Obsidian backlinks
		picker = {
			name = "telescope.nvim",
		},

		-- Disable UI (render-markdown.nvim handles this)
		ui = {
			enable = false,
		},

		-- Use new command format only (:Obsidian <subcommand>)
		legacy_commands = false,

		-- Default keymaps are set automatically:
		-- <CR> = smart_action, gf = follow link, ]o/[o = nav links
		-- To customize, use callbacks.enter_note (see :Obsidian help Keymaps)
	},
}
