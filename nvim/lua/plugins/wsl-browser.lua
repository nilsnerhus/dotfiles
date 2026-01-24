-- WSL browser integration
-- Opens URLs in Windows browser when running in WSL using wsl-open
-- This overrides vim.ui.open() so gx and plugins work correctly
--
-- Requires: npm install -g wsl-open
-- See: https://github.com/4U6U57/wsl-open

return {
  {
    dir = vim.fn.stdpath("config"),
    name = "wsl-browser",
    lazy = false,
    cond = function()
      -- Only load when running in WSL
      return vim.fn.has("wsl") == 1
    end,
    config = function()
      vim.ui.open = function(url)
        vim.fn.system({ "wsl-open", url })
      end
    end,
  },
}
