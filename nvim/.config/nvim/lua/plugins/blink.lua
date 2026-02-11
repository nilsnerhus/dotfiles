return {
	{ -- Autocompletion
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			-- Snippet Engine
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					-- {
					--   'rafamadriz/friendly-snippets',
					--   config = function()
					--     require('luasnip.loaders.from_vscode').lazy_load()
					--   end,
					-- },
				},
				opts = {},
			},
			"folke/lazydev.nvim",
			"jmbuhr/cmp-pandoc-references",
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			appearance = { nerd_font_variant = "mono" },
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 100,
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "lazydev", "references" },
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
						transform_items = function(ctx, items)
							for _, item in ipairs(items) do
								if item.documentation and item.documentation.value then
									-- Parse documentation to extract title, author, year
									local doc = item.documentation.value
									local lines = vim.split(doc, "\n")
									local title = lines[1] and lines[1]:gsub("^%*+", ""):gsub("%*+$", "") or ""
									local author = lines[3] and lines[3]:gsub("^%*", ""):gsub("%*$", "") or ""
									local year = lines[4] or ""
									-- Create searchable filterText: citation_key title author year
									item.filterText = item.label .. " " .. title .. " " .. author .. " " .. year
								end
							end
							return items
						end,
					},
				},
			},
			snippets = { preset = "luasnip" },
			fuzzy = { implementation = "prefer_rust_with_warning" },
			signature = { enabled = true },
		},
	},
}
