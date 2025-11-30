return {
  -- Quarto plugin
  {
    'quarto-dev/quarto-nvim',
    dependencies = { 'jmbuhr/otter.nvim', 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('quarto').setup {
        debug = false,
        closePreviewOnExit = true,
        lspFeatures = {
          enabled = true,
          chunks = 'curly',
          languages = { 'r', 'python', 'julia', 'bash', 'html' },
          diagnostics = { enabled = true, triggers = { 'BufWritePost' } },
          completion = { enabled = true },
        },
        codeRunner = { enabled = true, default_method = 'iron', never_run = { 'yaml' } },
      }
    end,
  },
  -- Markview plugin
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('markview').setup {
        modes = { 'n', 'no', 'c' },
        hybrid_modes = { 'n' },
        tables = { enable = true, headerless = true },
        filetypes = { 'quarto', 'markdown_inline', 'markdown' },
      }
    end,
  },
}
