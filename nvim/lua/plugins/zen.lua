return {
  'folke/zen-mode.nvim',
  opts = {
    window = {
      backdrop = 1, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
      width = 80, -- width of the Zen window
      height = 1, -- height of the Zen window
      options = {
        signcolumn = 'yes', -- display signcolumn
        number = true, -- display number
        relativenumber = true, -- display relative number
        cursorline = true, -- display cursorline
        cursorcolumn = false, -- disable cursor column
        foldcolumn = '1', -- disable fold column
        list = false, -- disable whitespace characters
        wrap = true,
        linebreak = true, -- Break on words, not characters
        breakindent = true, -- Preserve indentation on wrapped lines
      },
    },
    plugins = {
      options = {
        enabled = true,
        ruler = true,
        showcmd = true,
        laststatus = 3,
      },
      gitsigns = { enabled = true }, -- enables git signs
    },
  },
  keys = {
    { '<leader>z', '<cmd>ZenMode<cr>', desc = 'Zen Mode' },
  },
  config = function(_, opts)
    require('zen-mode').setup(opts)

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'markdown', 'quarto' },
      callback = function()
        vim.schedule(function()
          require('zen-mode').toggle()
        end)
      end,
      desc = 'Auto-enable Zen Mode for markdown/quarto',
    })
  end,
}
