-- CLI Keybinds
-- Sets up keybindings for the CLI framework

local M = {}
local operator = require("cli.operator")

---Setup all keybindings for the CLI framework
---This is the main entry point called during plugin initialization
function M.setup()
	-- Set up the send operator (s + motion, ss for line, visual s)
	operator.setup_operator()
end

return M
