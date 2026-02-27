return {
	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			"folke/lazydev.nvim",
			"jmbuhr/cmp-pandoc-references",
		},
		opts = {
			appearance = { nerd_font_variant = "mono" },
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 100,
				},
			},
			sources = {
				default = { "lsp", "path", "lazydev", "references" },
				providers = {
					lazydev = {
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
					references = {
						name = "pandoc_references",
						module = "cmp-pandoc-references.blink",
						enabled = function()
							local filetype = vim.bo.filetype
							return filetype == "markdown"
								or filetype == "quarto"
								or filetype == "pandoc"
								or filetype == "rmd"
								or filetype == "typst"
						end,
					},
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
			signature = { enabled = true },
		},
	},
}
