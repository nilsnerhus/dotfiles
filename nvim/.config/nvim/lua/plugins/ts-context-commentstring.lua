-- ts-context-commentstring.lua - Context-aware commenting for mixed-language files
-- Enables proper comment syntax based on cursor position using treesitter
-- Essential for quarto files (YAML frontmatter + markdown + code blocks)
--
-- Works with Neovim 0.10+ native commenting (gcc, gc, etc.)
-- Without this: quarto files always use # comments everywhere
-- With this: YAML uses #, markdown uses <!-- -->, code blocks use language-specific comments

return {
	"JoosepAlviste/nvim-ts-context-commentstring",
	event = "BufReadPost",
	opts = {
		enable_autocmd = false,
		config = {
			markdown = "<!-- %s -->",
		},
	},
	config = function(_, opts)
		require("ts_context_commentstring").setup(opts)

		-- Integration with native Neovim 0.10 commenting
		local get_option = vim.filetype.get_option
		vim.filetype.get_option = function(filetype, option)
			if option == "commentstring" then
				local commentstring = require("ts_context_commentstring.internal").calculate_commentstring()
				if commentstring then
					return commentstring
				end
			end
			return get_option(filetype, option)
		end
	end,
}
