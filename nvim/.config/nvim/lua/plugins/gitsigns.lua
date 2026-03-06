return {
	"lewis6991/gitsigns.nvim",
	opts = {
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

			-- Text object
			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
		end,
	},
}
