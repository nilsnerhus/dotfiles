local anki = require("anki")
local M = {}

local function has_cloze(text)
	return text:match("%[.-%]") ~= nil
end

local function convert_cloze(text)
	local n = 0
	return text:gsub("%[(.-)%]", function(content)
		n = n + 1
		return "{{c" .. n .. "::" .. content .. "}}"
	end)
end

local function extract_deck_name(lines)
	for _, line in ipairs(lines) do
		local name = line:match("^#%s+(.+)$")
		if name then
			return vim.trim(name)
		end
	end
	return nil
end

local function is_list_item(line)
	return line:match("^%s*[-*+]%s+") or line:match("^%s*%d+%.%s+")
end

local function split_blocks(lines)
	local blocks = {}
	local current = {}
	local start_index = 1

	for i, line in ipairs(lines) do
		if line:match("^#%s+") then
			start_index = i + 1
			break
		end
	end

	for i = start_index, #lines do
		local line = lines[i]
		if line:match("^%s*$") then
			local next_content = nil
			for j = i + 1, #lines do
				if not lines[j]:match("^%s*$") then
					next_content = lines[j]
					break
				end
			end
			if next_content and is_list_item(next_content) then
				table.insert(current, line)
			elseif #current > 0 then
				table.insert(blocks, current)
				current = {}
			end
		else
			table.insert(current, line)
		end
	end
	if #current > 0 then
		table.insert(blocks, current)
	end
	return blocks
end

local function classify_block(block)
	local full_text = table.concat(block, "\n")

	if has_cloze(full_text) then
		return "cloze", convert_cloze(full_text)
	end

	for i, line in ipairs(block) do
		if line:match("^::%s*$") or line == "::" then
			local front_lines = {}
			local back_lines = {}
			for j = 1, i - 1 do
				table.insert(front_lines, block[j])
			end
			for j = i + 1, #block do
				table.insert(back_lines, block[j])
			end
			return "card", table.concat(front_lines, "\n"), table.concat(back_lines, "\n")
		end

		local front, back = line:match("^(.-)%s*::%s*(.+)$")
		if front and back then
			return "card", vim.trim(front), vim.trim(back)
		end
	end

	return nil
end

local function parse(lines)
	local deck_name = extract_deck_name(lines)
	if not deck_name then
		return nil, nil
	end

	local blocks = split_blocks(lines)
	local cards = {}

	for _, block in ipairs(blocks) do
		local type, a, b = classify_block(block)
		if type == "card" then
			table.insert(cards, {
				front = a,
				back = b,
			})
		elseif type == "cloze" then
			table.insert(cards, {
				text = a,
			})
		end
	end

	return deck_name, cards
end

function M.sync()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local deck_name, cards = parse(lines)

	if not deck_name then
		vim.notify("Anki: No '# Heading' found", vim.log.levels.WARN)
		return
	end

	anki.sync(deck_name, cards)
end

return M
