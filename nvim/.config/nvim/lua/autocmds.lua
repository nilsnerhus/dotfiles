vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("user-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "gitcommit",
	callback = function()
		vim.cmd("wincmd L")
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "quarto",
	callback = function()
		require("otter").activate()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "csv", "tsv" },
	callback = function()
		vim.cmd("CsvViewEnable")
	end,
})

local augroup = vim.api.nvim_create_augroup("auto-win-width", { clear = true })

vim.api.nvim_create_autocmd("WinEnter", {
	group = augroup,
	callback = function()
		local win = vim.api.nvim_get_current_win()
		local config = vim.api.nvim_win_get_config(win)
		if config.relative ~= "" then
			return
		end
		if vim.fn.winnr("$") > 1 then
			vim.api.nvim_win_set_width(0, 80)
		end
	end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*/anki/*.md",
	callback = function()
		require("flashcards").sync()
	end,
})
