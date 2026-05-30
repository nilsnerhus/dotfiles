return {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml" },
	root_markers = { ".git" },
	settings = {
		yaml = {
			format = { enable = true },
			schemaStore = { enable = true },
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
				["https://json.schemastore.org/github-action.json"] = "action.y*ml",
				["https://taskfile.dev/schema.json"] = "Taskfile*.y*ml",
			},
		},
	},
}
