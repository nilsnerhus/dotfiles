vim.lsp.config("marksman", {
	cmd = { "marksman" },
	filetypes = { "markdown", "quarto" },
	root_markers = { ".git" },
})

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".git" },
})

vim.lsp.config("yamlls", {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml" },
	root_markers = { ".git" },
	settings = {
		yaml = {
			format = { enable = true },
			schemaStore = { enable = true },
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
				["https://taskfile.dev/schema.json"] = "taskfile.yml",
			},
		},
	},
})

vim.lsp.enable({
	"marksman",
	"lua_ls",
	"yamlls",
})

vim.diagnostic.config({
	severity_sort = true,
	signs = true,
})
