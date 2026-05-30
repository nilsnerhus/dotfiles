vim.lsp.config.marksman = require("lsp.marksman")
vim.lsp.config["r-languageserver"] = require("lsp.r-languageserver")
vim.lsp.config.lua_ls = require("lsp.lua_ls")
vim.lsp.config.yamlls = require("lsp.yamlls")
vim.lsp.config.tinymist = require("lsp.tinymist")
vim.lsp.config.ty = require("lsp.ty")

vim.lsp.enable({
	"marksman",
	"r-languageserver",
	"lua_ls",
	"yamlls",
	"tinymist",
	"ty",
})

vim.diagnostic.config({
	severity_sort = true,
	signs = true,
})
