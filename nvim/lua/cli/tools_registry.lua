-- CLI Tools Registry
-- Manages registration and retrieval of CLI tools

local M = {}

-- Internal registry of all registered tools
local tools = {}

---Register a tool with the CLI framework
---@param name string Unique identifier for the tool (e.g., "rrepl", "opencode")
---@param config table Tool configuration with required fields:
---  - id: single character identifier (e.g., "r", "o")
---  - name: human-readable name (e.g., "R REPL")
---  - send_fn: function(content, modifier) that sends content to the tool
---  - modifiers: (optional) table of modifiers { a = {name = "Ask"}, ... }
function M.register(name, config)
	if not name or type(name) ~= "string" then
		error("Tool name must be a non-empty string")
	end

	if not config or type(config) ~= "table" then
		error("Tool config must be a table")
	end

	-- Validate required fields
	local required_fields = { "id", "name", "send_fn" }
	for _, field in ipairs(required_fields) do
		if not config[field] then
			error(string.format("Tool '%s' missing required field: %s", name, field))
		end
	end

	if type(config.send_fn) ~= "function" then
		error(string.format("Tool '%s' send_fn must be a function", name))
	end

	tools[name] = config
end

---Retrieve all registered tools
---@return table Dictionary of all registered tools
function M.get()
	return tools
end

---Retrieve a specific tool by name
---@param name string Tool name
---@return table|nil Tool configuration or nil if not found
function M.get_tool(name)
	return tools[name]
end

---Get tool by single-char ID
---@param id string Single character ID (e.g., "r", "o")
---@return string|nil Tool name with matching ID, or nil
function M.get_tool_by_id(id)
	for tool_name, tool_config in pairs(tools) do
		if tool_config.id == id then
			return tool_name
		end
	end
	return nil
end

---Check if a tool is registered
---@param name string Tool name
---@return boolean True if tool is registered
function M.is_registered(name)
	return tools[name] ~= nil
end

return M
