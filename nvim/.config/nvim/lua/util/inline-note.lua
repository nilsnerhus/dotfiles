local M = {}

---Parse wiki link at cursor position
---@param line string Current line content
---@param col number Cursor column (0-indexed)
---@return string|nil note_name The note name without brackets
---@return number|nil start_col Start column of the link
---@return number|nil end_col End column of the link
local function parse_wiki_link(line, col)
	-- Find all wiki links in the line
	for start_idx, content, end_idx in line:gmatch("()(%[%[[^%]]+%]%])()") do
		local link_start = start_idx - 1
		local link_end = end_idx - 1
		
		-- Check if cursor is inside this link
		if col >= link_start and col <= link_end then
			-- Extract note name from [[note-name]] or [[note-name#heading]]
			local note_ref = content:match("%[%[([^%]]+)%]%]")
			if note_ref then
				-- Check for heading reference
				if note_ref:find("#") then
					return nil, nil, nil, "Cannot inline notes with heading references (atomic notes only)"
				end
				return note_ref, link_start, link_end
			end
		end
	end
	
	return nil, nil, nil, "No wiki-link found under cursor"
end

---Resolve note file path using LSP (marksman)
---@param note_name string The note name from the link (unused, kept for compatibility)
---@param row number 0-indexed row of the link
---@param col number 0-indexed column of the link
---@return string|nil filepath Full path to the note file
---@return string|nil error Error message if not found
local function resolve_note_path(note_name, row, col)
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "marksman" })
	
	if #clients == 0 then
		return nil, "marksman LSP not attached to this buffer"
	end
	
	local client = clients[1]
	local position = { line = row, character = col }
	local params = {
		textDocument = vim.lsp.util.make_text_document_params(bufnr),
		position = position,
	}
	
	-- Request definition from marksman
	local response = client.request_sync("textDocument/definition", params, 5000, bufnr)
	
	if not response or response.err then
		return nil, "LSP error: " .. (response and response.err or "no response")
	end
	
	local result = response.result
	if not result or vim.tbl_isempty(result) then
		return nil, "Note '" .. note_name .. "' not found by marksman"
	end
	
	-- Get the first location
	local location = result[1] or result
	if location.uri then
		local filepath = vim.uri_to_fname(location.uri)
		if vim.fn.filereadable(filepath) == 1 then
			return filepath, nil
		end
	end
	
	return nil, "Could not resolve note path from LSP response"
end

---Read file and process content
---@param filepath string Path to the note file
---@return table|nil lines Array of content lines
---@return string|nil error Error message
local function read_and_process_content(filepath)
	local lines = vim.fn.readfile(filepath)
	if #lines == 0 then
		return nil, "Note file is empty"
	end
	
	local result = {}
	local in_frontmatter = false
	local frontmatter_started = false
	local in_code_block = false
	
	for _, line in ipairs(lines) do
		-- Track code blocks
		if line:match("^```") then
			in_code_block = not in_code_block
			table.insert(result, line)
			goto continue
		end
		
		-- Skip frontmatter
		if not in_code_block then
			if line:match("^%-%-%-$") then
				if not frontmatter_started then
					in_frontmatter = true
					frontmatter_started = true
					goto continue
				elseif in_frontmatter then
					in_frontmatter = false
					goto continue
				end
			end
			
			if in_frontmatter then
				goto continue
			end
			
			-- Downgrade H1 to H2 (but not in code blocks)
			if line:match("^# ") then
				line = "##" .. line:sub(2)
			end
		end
		
		table.insert(result, line)
		
		::continue::
	end
	
	-- Remove leading empty lines
	while #result > 0 and result[1]:match("^%s*$") do
		table.remove(result, 1)
	end
	
	-- Remove trailing empty lines
	while #result > 0 and result[#result]:match("^%s*$") do
		table.remove(result)
	end
	
	if #result == 0 then
		return nil, "Note has no content after processing"
	end
	
	return result, nil
end

---Preview what would be inlined (dry-run)
---@return boolean success
function M.inline_note_test()
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1] - 1  -- 0-indexed
	local col = cursor[2]
	
	-- Get current line
	local lines = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)
	if #lines == 0 then
		vim.notify("Empty line", vim.log.levels.ERROR)
		return false
	end
	local line = lines[1]
	
	-- Parse wiki link
	local note_name, _, _, err = parse_wiki_link(line, col)
	if not note_name then
		vim.notify(err or "No wiki-link found", vim.log.levels.ERROR)
		return false
	end
	
	-- Resolve path using LSP
	local filepath, path_err = resolve_note_path(note_name, row, col)
	if not filepath then
		vim.notify(path_err or "Could not resolve note path", vim.log.levels.ERROR)
		return false
	end
	
	-- Read and process content
	local content_lines, content_err = read_and_process_content(filepath)
	if not content_lines then
		vim.notify(content_err or "Could not read note content", vim.log.levels.ERROR)
		return false
	end
	
	-- Show preview
	local preview = table.concat(content_lines, "\n")
	local msg = string.format(
		"Would inline '%s' (%d lines):\n\n%s\n\nSource file: %s\n(This would be deleted after inlining)",
		note_name,
		#content_lines,
		preview:sub(1, 500) .. (preview:len() > 500 and "..." or ""),
		filepath
	)
	
	vim.notify(msg, vim.log.levels.INFO, { title = "Obsidian Inline Preview" })
	return true
end

---Actually inline the note
---@return boolean success
function M.inline_note()
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1] - 1  -- 0-indexed
	local col = cursor[2]
	
	-- Get current line
	local lines = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)
	if #lines == 0 then
		vim.notify("Empty line", vim.log.levels.ERROR)
		return false
	end
	local line = lines[1]
	
	-- Parse wiki link
	local note_name, link_start, link_end, err = parse_wiki_link(line, col)
	if not note_name then
		vim.notify(err or "No wiki-link found", vim.log.levels.ERROR)
		return false
	end
	
	-- Resolve path using LSP
	local filepath, path_err = resolve_note_path(note_name, row, col)
	if not filepath then
		vim.notify(path_err or "Could not resolve note path", vim.log.levels.ERROR)
		return false
	end
	
	-- Read and process content
	local content_lines, content_err = read_and_process_content(filepath)
	if not content_lines then
		vim.notify(content_err or "Could not read note content", vim.log.levels.ERROR)
		return false
	end
	
	-- Prepare text edit
	-- Replace the link with the content
	local new_lines = {}
	
	-- Text before the link
	local before_link = line:sub(1, link_start)
	-- Text after the link
	local after_link = line:sub(link_end + 1)
	
	-- First line: text before link + first line of content
	if before_link:match("^%s*$") then
		-- Link is at start of line, just use content
		table.insert(new_lines, content_lines[1])
	else
		table.insert(new_lines, before_link .. content_lines[1])
	end
	
	-- Middle lines: content as-is
	for i = 2, #content_lines - 1 do
		table.insert(new_lines, content_lines[i])
	end
	
	-- Last line: last line of content + text after link
	if #content_lines > 1 then
		if after_link:match("^%s*$") then
			table.insert(new_lines, content_lines[#content_lines])
		else
			table.insert(new_lines, content_lines[#content_lines] .. after_link)
		end
	else
		-- Only one line of content
		if not after_link:match("^%s*$") then
			new_lines[#new_lines] = new_lines[#new_lines] .. after_link
		end
	end
	
	-- Apply text edit
	vim.api.nvim_buf_set_lines(bufnr, row, row + 1, false, new_lines)
	
	-- Delete the source file
	local delete_ok = vim.fn.delete(filepath) == 0
	
	-- Notify
	local msg = string.format(
		"Inlined '%s' (%d lines)",
		note_name,
		#content_lines
	)
	if not delete_ok then
		msg = msg .. " (Warning: Could not delete source file)"
	end
	
	vim.notify(msg, vim.log.levels.INFO, { title = "Obsidian Inline" })
	return true
end

return M
