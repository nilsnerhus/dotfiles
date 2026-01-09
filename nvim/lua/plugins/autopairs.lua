-- autopairs - smart bracket pairing that respects custom keymaps
-- https://github.com/windwp/nvim-autopairs
--
-- Special handling for [[ wiki-link trigger:
-- In markdown files, when you type [[, we want the custom keymap to fire
-- (opening Telescope), NOT autopairs' automatic ]] pairing.
-- Solution: Create a rule that skips pairing [ when preceded by another [

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    local npairs = require('nvim-autopairs')
    local Rule = require('nvim-autopairs.rule')
    
    -- Default setup
    npairs.setup({})
    
    -- Custom rule: Don't auto-pair [ if it's preceded by another [
    -- This allows [[  to pass through unpaired, so the markdown ftplugin
    -- keymap can detect it and open the wiki-link picker
    npairs.add_rules({
      Rule('[', ']')
        :with_pair(function(options)
          local line = options.line
          local col = options.col
          
          -- Get the character immediately before cursor
          -- If there's a [ before this [, skip auto-pairing
          if col > 1 then
            local prev_char = line:sub(col - 1, col - 1)
            if prev_char == '[' then
              -- Don't pair - let the custom keymap handle [[
              return false
            end
          end
          
          -- Normal behavior: pair the bracket
          return true
        end)
    })
  end,
}
