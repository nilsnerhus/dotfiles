local function get_backlog_files(inverse)
  local files = {}
  local backlog_path = '/home/nilsn/prosjekter/backlog'

  for _, file in ipairs(vim.fn.glob(backlog_path .. '/**/*.md', false, true)) do
    local mod_time = vim.fn.getftime(file)
    local rel_path = file:gsub(backlog_path .. '/', '')
    table.insert(files, {
      filename = file,
      display = rel_path,
      ordinal = rel_path,
      mod_time = mod_time
    })
  end

  table.sort(files, function(a, b)
    if inverse then
      return a.mod_time < b.mod_time -- Oldest first
    else
      return a.mod_time > b.mod_time -- Newest first
    end
  end)

  return files
end

local function show_backlog(inverse)
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  pickers.new({}, {
    prompt_title = inverse and "Backlog - Neglected Projects" or "Backlog - Current Interests",
    finder = finders.new_table({
      results = get_backlog_files(inverse),
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.display,
          ordinal = entry.ordinal
        }
      end
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        vim.cmd('edit ' .. action_state.get_selected_entry().value.filename)
      end)
      return true
    end
  }):find()
end

-- Add keymaps
vim.keymap.set('n', '<leader>sb', function() show_backlog(false) end, { desc = '[S]earch [B]acklog - Recent' })
vim.keymap.set('n', '<leader>sB', function() show_backlog(true) end, { desc = '[S]earch [B]acklog - Old' })

return {}