-- FIX: Add the processing of markdown in floating buffers, so that the table could be viewed inline
-- FIX: If possible, make markdown tables able to overflow 80 chars, and just take up space if needed.
-- FIX: Make it conceal the base file name for files where I use the heading name
return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown", "quarto" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			file_types = { "markdown", "quarto" },
			latex = { enabled = false },
			code = { conceal_delimiters = false },
			html = {
				comment = { conceal = false },
				highlight = true,
			},
			link = {
				wiki = {
					enabled = true,
					icon = "󱗖 ",
					body = function(ctx)
						if ctx.destination:find("#") then
							local heading = ctx.destination:match("#(.+)$")
							if heading then
								return heading
							end
						end
						return nil
					end,
					highlight = "RenderMarkdownWikiLink",
					scope_highlight = nil,
				},
			},
		},
	},
}
