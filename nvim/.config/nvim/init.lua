-- --- vim.options
-- set global vim options
vim.o.number = true -- shows absolute line numbers
vim.o.cursorline = true -- highlights the current line
vim.o.relativenumber = true -- shows relative numbers on other lines
vim.o.scrolloff = 10 -- keeps 10 lines visible above/below the cursor

vim.o.linebreak = true -- wraps long lines at word boundaries

vim.o.clipboard = "unnamedplus" -- uses the system clipboard

-- ---
require("plugins") -- loads file with plugin-config
require("lsp") -- loads file with lsp-config
require("keymaps") -- loads file with keymaps
