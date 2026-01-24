-- treesitter.lua - Syntax highlighting and code understanding
--
-- Treesitter parses your code into a syntax tree, enabling:
--   - Better syntax highlighting (understands code structure, not just patterns)
--   - Code folding
--   - Incremental selection
--   - Better indentation
--
-- See :help nvim-treesitter

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate", -- Automatically update parsers when plugin updates
  main = "nvim-treesitter.configs",
  opts = {
    -- Languages to install parsers for
    -- Run :TSInstall <language> to add more, or add them here
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
      -- Some languages need vim's regex highlighting for indent rules
      additional_vim_regex_highlighting = { "ruby" },
    },

    -- Indentation based on treesitter
    indent = {
      enable = true,
      disable = { "ruby" },
    },
  },

  -- Additional treesitter modules you might want to explore:
  --   - Incremental selection: :help nvim-treesitter-incremental-selection-mod
  --   - Show current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --   - Text objects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
