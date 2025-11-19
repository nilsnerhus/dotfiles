return {
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
            command = { '/home/nilsn/.local/bin/radian' },
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
        send_motion = '<leader>sc',
        visual_send = '<leader>sc',
        -- send_file = '<leader>sf',
        send_line = '<leader>sl',
        send_paragraph = '<leader>sp',
        send_until_cursor = '<leader>su',
        send_mark = '<leader>sm',
        mark_motion = '<leader>mc',
        mark_visual = '<leader>mc',
        remove_mark = '<leader>md',
        cr = '<leader>s<cr>',
        interrupt = '<leader>s<space>',
        exit = '<leader>sq',
        clear = '<leader>cl',
      },
      -- If the highlight is on, you can change how it looks
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    }
  end,
}
