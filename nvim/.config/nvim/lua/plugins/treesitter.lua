return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate", -- Automatically update parsers when plugin updates
	main = "nvim-treesitter.configs",
	opts = {
		ensure_installed = {
			"bash",
			"c",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"r", -- For R code
			"vim",
			"vimdoc",
			"yaml", -- For Quarto/R Markdown frontmatter
		},

		-- Automatically install parsers when entering a buffer
		auto_install = true,

		-- Syntax highlighting
		highlight = {
			enable = true,
		},
	},
}
