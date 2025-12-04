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

  -- Obsidian.nvim: The "Brain" (Vault, Links, Daily Notes)
  {
    'epwalsh/obsidian.nvim',
    version = '*', -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = 'markdown',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      workspaces = {
        {
          name = 'jobb',
          path = '/home/nilsn/prosjekter/jobb',
        },
      },
      -- Disable UI features that might conflict with markview.nvim
      ui = {
        enable = false,
      },
    },
  },

  -- Vim-table-mode: The "Editor" (Auto-align tables)
  {
    'dhruvasagar/vim-table-mode',
    ft = { 'markdown', 'quarto' },
    init = function()
      -- Use markdown-compatible table corners
      vim.g.table_mode_corner = '|'
    end,
  },

  -- Markview plugin: The "Look" (Rendering)
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('markview').setup {
        filetypes = { 'quarto', 'markdown_inline', 'markdown' },
        hybrid_modes = { 'n' },
        line_wise_hybrid_mode = { 'n' },
        
        -- Configuration for newer versions of markview
        markdown = {
          tables = {
            enable = true,
            block_decorator = true,
            use_virt_lines = true,
          },
        },
        
        -- Fallback/Legacy configuration
        tables = { enable = true },
      }
    end,
  },
}
