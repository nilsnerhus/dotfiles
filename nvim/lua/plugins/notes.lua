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
          languages = { 'r' },
          diagnostics = { enabled = true, triggers = { 'BufWritePost' } },
          completion = { enabled = true },
        },
        codeRunner = { enabled = true, default_method = 'iron', never_run = { 'yaml' } },
      }
    end,
  },

  -- Obsidian.nvim
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    lazy = true,
    ft = 'markdown, quarto',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      workspaces = {
        {
          name = 'backlog',
          path = '/home/nilsn/prosjekter/backlog/',
        },
        {
          name = 'notater',
          path = '/home/nilsn/prosjekter/notater/',
        },
      },
    },
  },

  -- Render-markdown.nvim
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = { 'markdown', 'quarto' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = { 'markdown', 'quarto' },
      link = {
        wiki = { icon = '🔗 ' },
      },
      code = {
        sign = false,
        width = 'block',
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = {},
      },
      checkbox = {
        enabled = true,
      },
    },
  },
}
