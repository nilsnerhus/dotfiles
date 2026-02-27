-- gitsigns.lua - Git integration for Neovim
-- Shows git diff signs in the sign column and provides hunk operations
-- See :help gitsigns for more info
--
-- Workflow suggestion:
--   1. <leader>sg - Search git status (telescope) to see all changed files
--   2. Navigate to files and use gitsigns keymaps below to stage/reset hunks
--   3. For commits, consider adding vim-fugitive (:G commit) or neogit
--   4. Use trouble.nvim to view diagnostics while working on changes

return {
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = { text = "│" },
			change = { text = "│" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signcolumn = true,
		numhl = false,
		linehl = false,
		word_diff = false,
		watch_gitdir = {
			follow_files = true,
		},
		auto_attach = true,
		attach_to_untracked = false,
		current_line_blame = false, -- Toggle with <leader>tb
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 1000,
			ignore_whitespace = false,
			virt_text_priority = 100,
		},
		current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil,
		max_file_length = 40000,
		preview_config = {
			border = "single",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map("n", "]h", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, { desc = "Next [H]unk" })

			map("n", "[h", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, { desc = "Previous [H]unk" })

			-- Actions
			map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "[H]unk [S]tage" })
			map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "[H]unk [R]eset" })
			map("v", "<leader>hs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "[H]unk [S]tage" })
			map("v", "<leader>hr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "[H]unk [R]eset" })
			map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "[H]unk [S]tage buffer" })
			map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "[H]unk [U]ndo stage" })
			map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "[H]unk [R]eset buffer" })
			map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "[H]unk [P]review" })
			map("n", "<leader>hb", function()
				gitsigns.blame_line({ full = true })
			end, { desc = "[H]unk [B]lame line" })
			map("n", "<leader>hd", gitsigns.diffthis, { desc = "[H]unk [D]iff this" })
			map("n", "<leader>hD", function()
				gitsigns.diffthis("~")
			end, { desc = "[H]unk [D]iff this ~" })

			-- Toggles (also mapped under <leader>t for consistency)
			map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git [B]lame" })
			map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "[T]oggle git [D]eleted" })
			map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "[T]oggle [W]ord diff" })

			-- Text object
			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
		end,
	},
}
