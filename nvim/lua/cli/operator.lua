-- CLI Operator
-- Handles operator-pending mode for the send operator (s)
-- Flow: s + motion → tool selection → optional modifier → send

local M = {}
local core = require("cli.core")
local registry = require("cli.tools_registry")

-- Track operator state
M.state = {
	pending_content = nil,
	pending_tool = nil,
}

---The main operator function called after motion is captured
---Called as: vim.o.operatorfunc = 'v:lua.require("cli.operator").send_operator'
---At this point, vim has set marks '[' and ']' with the motion bounds
---@param motion_type string Type of motion ('char', 'line', 'block')
function M.send_operator(motion_type)
	-- Get content between marks
	local content = core.get_selection()

	if not content or content == "" then
		vim.notify("No content selected by motion", vim.log.levels.WARN)
		return
	end

	-- Store content and prompt for tool selection
	M.state.pending_content = content
	M.prompt_for_tool()
end

---Prompt user to select a tool
---Uses vim.ui.select for interactive selection
function M.prompt_for_tool()
	local tools = registry.get()
	local tool_names = {}
	local tool_labels = {}

	for name, config in pairs(tools) do
		table.insert(tool_names, name)
		table.insert(tool_labels, "[" .. config.id .. "] " .. config.name)
	end

	if #tool_names == 0 then
		vim.notify("No tools registered", vim.log.levels.WARN)
		M.cleanup()
		return
	end

	vim.ui.select(tool_labels, {
		prompt = "Send to: ",
	}, function(choice, idx)
		if choice and idx then
			M.state.pending_tool = tool_names[idx]
			M.prompt_for_modifier()
		else
			M.cleanup()
		end
	end)
end

---Prompt user to select a modifier (if the tool has any)
function M.prompt_for_modifier()
	if not M.state.pending_tool then
		M.cleanup()
		return
	end

	local tool = registry.get_tool(M.state.pending_tool)

	if not tool then
		vim.notify("Tool not found: " .. M.state.pending_tool, vim.log.levels.ERROR)
		M.cleanup()
		return
	end

	-- If tool has no modifiers, send immediately
	if not tool.modifiers or vim.tbl_isempty(tool.modifiers) then
		M.execute_send(nil)
		return
	end

	-- Show modifier selection
	local mod_ids = {}
	local mod_labels = {}

	-- Add "default" option first
	table.insert(mod_ids, nil)
	table.insert(mod_labels, "[enter] Default (no modifier)")

	for mod_id, mod_config in pairs(tool.modifiers) do
		table.insert(mod_ids, mod_id)
		table.insert(mod_labels, "[" .. mod_id .. "] " .. mod_config.name)
	end

	vim.ui.select(mod_labels, {
		prompt = "Modifier: ",
	}, function(choice, idx)
		if choice and idx then
			M.execute_send(mod_ids[idx])
		else
			M.cleanup()
		end
	end)
end

---Execute the send with stored content and selected tool/modifier
---@param modifier string|nil Modifier ID
function M.execute_send(modifier)
	if not M.state.pending_content or not M.state.pending_tool then
		vim.notify("No content or tool selected", vim.log.levels.WARN)
		M.cleanup()
		return
	end

	core.send(M.state.pending_tool, M.state.pending_content, modifier)
	M.cleanup()
end

---Clean up operator state
function M.cleanup()
	M.state.pending_content = nil
	M.state.pending_tool = nil
end

---Direct send to a specific tool (bypasses motion, uses current line or selection)
---@param tool_name string Tool name
---@param modifier string|nil Optional modifier
function M.send_direct(tool_name, modifier)
	local content = core.get_selection()

	if not content or content == "" then
		vim.notify("No content to send", vim.log.levels.WARN)
		return
	end

	core.send(tool_name, content, modifier)
end

---Setup the send operator keybinding
---Enters operator-pending mode when user presses 's'
function M.setup_operator()
	-- Normal mode: s + motion
	vim.keymap.set("n", "s", function()
		vim.o.operatorfunc = 'v:lua.require("cli.operator").send_operator'
		return "g@"
	end, {
		expr = true,
		desc = "[S]end (operator, awaits motion)",
	})

	-- Visual mode: s triggers tool selection for visual selection
	vim.keymap.set("x", "s", function()
		-- Exit visual mode first to set the '< and '> marks
		vim.cmd("normal! ")
		-- Get the visual selection
		local start_pos = vim.api.nvim_buf_get_mark(0, "<")
		local end_pos = vim.api.nvim_buf_get_mark(0, ">")
		local lines = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, end_pos[1], false)
		local content = table.concat(lines, "\n")

		if not content or content == "" then
			vim.notify("No content selected", vim.log.levels.WARN)
			return
		end

		M.state.pending_content = content
		M.prompt_for_tool()
	end, {
		desc = "[S]end selection",
	})

	-- ss sends current line (like dd, yy, cc)
	vim.keymap.set("n", "ss", function()
		local line = vim.fn.getline(".")
		if not line or line == "" then
			vim.notify("Current line is empty", vim.log.levels.WARN)
			return
		end
		M.state.pending_content = line
		M.prompt_for_tool()
	end, {
		desc = "[S]end current line",
	})
end

return M
