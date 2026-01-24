-- spell.lua - Neovim built-in spell checking configuration
-- This configures Neovim's native spell feature, not an external plugin
-- See :help spell for documentation
--
-- Usage:
--   <leader>ts  Toggle spell checking on/off
--   ]s          Jump to next misspelled word (built-in)
--   [s          Jump to previous misspelled word (built-in)
--   z=          Show spelling suggestions (built-in)
--   zg          Add word under cursor to dictionary (built-in)
--   zw          Mark word as incorrect (built-in)

return {
  -- This is a "virtual" plugin entry - it just runs configuration code
  -- We use this pattern to keep spell config organized with other plugins
  dir = vim.fn.stdpath("config"),
  name = "spell-config",
  lazy = false,
  config = function()
    -- Languages: Norwegian Bokmål (nb) + English (en)
    -- Neovim checks both languages simultaneously
    vim.opt.spelllang = { "nb", "en" }

    -- Keep spell checking OFF by default (on-demand workflow)
    -- Toggle with <leader>ts when you want to review spelling
    vim.opt.spell = false

    -- Toggle spell checking on/off
    -- Navigation (]s, [s) and actions (z=, zg) are built-in Neovim commands
    vim.keymap.set("n", "<leader>ts", function()
      vim.opt.spell = not vim.opt.spell:get()
      if vim.opt.spell:get() then
        vim.notify("Spell checking ON", vim.log.levels.INFO)
      else
        vim.notify("Spell checking OFF", vim.log.levels.INFO)
      end
    end, { desc = "[T]oggle [S]pell checking" })
  end,
}
