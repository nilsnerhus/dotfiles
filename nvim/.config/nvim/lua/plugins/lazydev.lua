-- lazydev.lua - Enhanced Lua LSP for Neovim config editing
-- Provides completion, annotations and signatures for Neovim APIs
-- This makes lua_ls understand vim.* functions when editing Neovim config
-- See :help lazydev.nvim

return {
  "folke/lazydev.nvim",
  ft = "lua", -- Only loads when editing Lua files
  opts = {
    library = {
      -- Load luvit types when vim.uv is found in the code
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
