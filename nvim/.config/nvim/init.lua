-- --- vim.options
-- set global vim options
vim.g.mapleader = " " -- sets <leader> for the rest of the config
vim.o.number = true -- shows absolute line numbers
vim.o.cursorline = true -- highlights the current line
vim.o.relativenumber = true -- shows relative numbers on other lines
vim.o.scrolloff = 10 -- keeps 10 lines visible above/below the cursor
vim.o.linebreak = true -- wraps long lines at word boundaries
vim.o.clipboard = "unnamedplus" -- uses the system clipboard


-- --- autocmd
-- define a autocmd for highlighting recently copied (yanked) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("user-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
-- --- Other modules
require("plugins") -- loads file with plugin-config
require("lsp") -- loads file with lsp-config
