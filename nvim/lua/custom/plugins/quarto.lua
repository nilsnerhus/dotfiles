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
  {
    'dhruvasagar/vim-table-mode',
    event = 'VeryLazy', -- Load when needed
    config = function()
      -- Table mode settings
      vim.g.table_mode_corner = '|'
      vim.g.table_mode_header_fillchar = '-'
      vim.g.table_mode_fillchar = ' '

      -- Keybindings for table mode
      vim.keymap.set('n', '<leader>tm', ':TableModeEnable<CR>', { desc = 'Enable table mode' })
      vim.keymap.set('n', '<leader>tM', ':TableModeDisable<CR>', { desc = 'Disable table mode' })
      vim.keymap.set('n', '<leader>tt', ':TableModeToggle<CR>', { desc = 'Toggle table mode' })
    end,
  },
}
