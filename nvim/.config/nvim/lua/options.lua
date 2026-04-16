vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.cursorline = true
vim.o.scrolloff = 15
vim.o.splitright = true

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split"

vim.o.ignorecase = true

vim.o.undofile = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.confirm = false

vim.o.spell = false
vim.o.spelllang = "nb,en_us"
vim.o.spelloptions = "camel"

vim.o.winwidth = 10
vim.o.winminwidth = 10
vim.o.equalalways = false

vim.opt.laststatus = 3
vim.opt.splitkeep = "screen"

vim.opt.clipboard = "unnamedplus"

vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. os.getenv("HOME") .. "/.local/bin:" .. vim.env.PATH

vim.ui.open = function(url)
	vim.fn.system({ "wsl-open", url })
end

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)
