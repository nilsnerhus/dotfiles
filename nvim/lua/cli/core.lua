-- CLI Core
-- Main send logic and helper functions

local M = {}
local tools_registry = require("cli.tools_registry")

---Get the currently selected content
---Handles three cases:
---1. Operator-pending mode: text between marks '[' and ']'
---2. Visual mode: current visual selection
---3. Normal mode (line): current line
---@return string Selected content
function M.get_selection()
	local mode = vim.fn.mode()

	-- Visual mode (v, V, or Ctrl-V)
	if mode == "v" or mode == "V" or mode == "\22" then
		-- Get visual selection using marks
		local start_pos = vim.api.nvim_buf_get_mark(0, "<")
		local end_pos = vim.api.nvim_buf_get_mark(0, ">")

		if start_pos[1] == 0 or end_pos[1] == 0 then
			-- Fallback if marks not set
			return vim.fn.getline(".")
		end

		local lines = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, end_pos[1], false)
		return table.concat(lines, "\n")
	end

	-- Operator-pending mode: use marks set by vim after motion
	-- (This function is called after motion is captured)
	local start_mark = vim.api.nvim_buf_get_mark(0, "[")
	local end_mark = vim.api.nvim_buf_get_mark(0, "]")

	if start_mark[1] ~= 0 and end_mark[1] ~= 0 then
		local lines = vim.api.nvim_buf_get_lines(0, start_mark[1] - 1, end_mark[1], false)
		return table.concat(lines, "\n")
	end

	-- Default: current line
	return vim.fn.getline(".")
end

---Send content to a tool using its send_fn
---@param tool_name string Name of the tool (e.g., "rrepl")
---@param content string Content to send
---@param modifier string|nil Optional modifier (e.g., "a" for ask mode)
function M.send(tool_name, content, modifier)
	local tool = tools_registry.get_tool(tool_name)

	if not tool then
		vim.notify("Tool not found: " .. tool_name, vim.log.levels.ERROR)
		return
	end

	-- Call the tool's send function
	local ok, err = pcall(tool.send_fn, content, modifier)

	if not ok then
		vim.notify("Failed to send to " .. tool.name .. ": " .. tostring(err), vim.log.levels.ERROR)
		return
	end

	vim.notify(
		string.format("Sent to %s%s", tool.name, modifier and " (" .. modifier .. ")" or ""),
		vim.log.levels.INFO
	)
end

return M
