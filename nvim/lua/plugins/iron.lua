return {
  -- iron plugin. Should be replaced with something that start the repl in a new pane, instead of buffer, to make it easier to work remotely
  'Vigemus/iron.nvim',
  keys = {
    { '<leader>rs', '<cmd>IronRepl<cr>', desc = 'Toggle REPL' },
    { '<leader>rr', '<cmd>IronRestart<cr>', desc = 'Restart REPL' },
    { '<leader>rf', '<cmd>IronFocus<cr>', desc = 'Focus REPL' },
    { '<leader>rh', '<cmd>IronHide<cr>', desc = 'Hide REPL' },
  },
  config = function()
    local iron = require 'iron.core'
    local view = require 'iron.view'

    iron.setup {
      config = {
        -- If iron should expose `<plug>(...)` mappings for the plugins
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
          r = {
            command = { 'R' },
          },
          python = {
            command = { 'ipython' },
          },
        },
        -- How the repl window will be opened
        repl_open_cmd = view.split.vertical.botright(50),
      },
      -- Iron doesn't set keymaps by default anymore.
      -- You can set them here or manually add keymaps to the features you want
      keymaps = {
        -- send_motion = '<leader>rc',
        visual_send = '<CR>',
        send_file = '<CR>',
        send_line = '<CR>',
        send_paragraph = '<leader><CR>',
      },
      -- If the highlight is on, you can change how it looks
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    }
  end,
}
