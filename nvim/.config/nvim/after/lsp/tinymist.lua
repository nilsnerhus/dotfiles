return {
	cmd = { "tinymist" },
	filetypes = { "typst" },
	settings = {
		tinymist = {
			formatterMode = "typstyle",
		},
	},
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = true
	end,
}
