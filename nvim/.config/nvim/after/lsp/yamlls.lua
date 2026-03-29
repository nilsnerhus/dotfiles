return {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
	root_markers = { ".git" },
	settings = {
		redhat = { telemetry = { enabled = false } },
		yaml = {
			format = { enable = false },
			schemaStore = { enable = true },
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
				["https://json.schemastore.org/github-action.json"] = "action.y*ml",
				["https://taskfile.dev/schema.json"] = "Taskfile*.y*ml",
			},
		},
	},
}
