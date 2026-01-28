-- CLI Framework
-- Main initialization module

local M = {}

-- Export core modules
M.core = require("cli.core")
M.registry = require("cli.tools_registry")
M.operator = require("cli.operator")
M.keybinds = require("cli.keybinds")

---Initialize the CLI framework with keybindings
---Call this from plugins/cli.lua during plugin setup
function M.setup()
  M.keybinds.setup()
end

return M
