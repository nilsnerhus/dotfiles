-- Wikilinks Filter for Quarto
-- Converts Obsidian-style [[id]] and [[id|display]] wikilinks to Markdown links
-- Usage: Add to _quarto.yml:
--   filters:
--     - filters/wikilinks.lua

-- Inline utils to avoid module loading issues
local function has_key(tbl, key)
	return tbl[key] ~= nil
end

local function trim(s)
	return s:match("^%s*(.-)%s*$")
end

local function ltrim(s)
	return s:gsub("^%s*", "")
end

local title_cache = nil

-- UTF-8 aware lowercase for Norwegian characters
local function utf8_lower(char)
	local upper_to_lower = {
		["Æ"] = "æ",
		["Ø"] = "ø",
		["Å"] = "å",
	}
	return upper_to_lower[char] or char:lower()
end

-- Iterator for UTF-8 characters
local function utf8_chars(text)
	local i = 1
	return function()
		if i > #text then
			return nil
		end
		local byte = text:byte(i)
		local char_len = 1
		if byte >= 0xC0 and byte <= 0xDF then
			char_len = 2
		elseif byte >= 0xE0 and byte <= 0xEF then
			char_len = 3
		elseif byte >= 0xF0 and byte <= 0xF4 then
			char_len = 4
		end
		local char = text:sub(i, i + char_len - 1)
		i = i + char_len
		return char
	end
end

local function slug_normalize(text)
	if not text or text == "" then
		return ""
	end

	text = trim(text)
	local result = {}
	local sep_needed = false

	for char in utf8_chars(text) do
		local byte = string.byte(char)
		local is_punct = char:match("[%^%$%(%)%%%.%[%]%*%+%-%?%%]")
			or (byte >= 33 and byte <= 47 and byte ~= 45)
			or (byte >= 58 and byte <= 64)
			or (byte >= 91 and byte <= 96 and byte ~= 95)
			or (byte >= 123 and byte <= 126)

		if is_punct then
			if #result > 0 then
				sep_needed = true
			end
		elseif char:match("%s") or char == "-" then
			if #result > 0 then
				sep_needed = true
			end
		else
			if sep_needed then
				table.insert(result, "-")
				sep_needed = false
			end
			table.insert(result, utf8_lower(char))
		end
	end

	return table.concat(result)
end

local function extract_h1_title(content)
	if not content then
		return nil
	end
	local pos = 1
	if content:sub(1, 3) == "---" then
		local end_pos = content:find("\n---", 4)
		if end_pos then
			pos = end_pos + 4
		end
	end
	for line in content:sub(pos):gmatch("[^\n]+") do
		local title = line:match("^%s*#%s+(.+)$")
		if title then
			return trim(title)
		end
	end
	return nil
end

local function get_quarto_prefix()
	-- Try to find quarto directory relative to current working directory
	local cwd = os.getenv("PWD") or ""

	-- Check if quarto exists in current directory
	local f = io.open("quarto/", "r")
	if f then
		f:close()
		return "quarto/"
	end

	-- Check if we're in quarto/ subdirectory
	if cwd:match("/quarto$") or cwd:match("/quarto/") then
		return ""
	end

	-- Check parent directory for quarto/
	f = io.open("../quarto/", "r")
	if f then
		f:close()
		return "../quarto/"
	end

	-- Default fallback
	return "quarto/"
end

local function scan_files(quarto_prefix)
	local cache = {}
	local cmd = string.format("ls -1 %s*.qmd 2>/dev/null", quarto_prefix)
	local handle = io.popen(cmd)
	if not handle then
		return cache
	end
	for filepath in handle:lines() do
		local filename = filepath:match("([^/]+)%.qmd$")
		if filename then
			local f = io.open(filepath, "r")
			if f then
				local content = f:read("*all")
				f:close()
				local title = extract_h1_title(content)
				if title then
					local slug = slug_normalize(title)
					if slug ~= "" then
						cache[slug] = filename
					end
				end
			end
		end
	end
	handle:close()
	return cache
end

local function build_title_cache(quarto_prefix)
	if not title_cache then
		title_cache = scan_files(quarto_prefix)
	end
	return title_cache
end

local function parse_wikilink(text)
	-- Match wikilink pattern even if followed by other text
	-- Extract the wikilink content between [[ and ]]
	local wikilink_content = text:match("%[%[(.-)%]%]")
	if not wikilink_content then
		return nil, nil, nil
	end

	local pipe_pos = wikilink_content:find("|")
	if pipe_pos then
		local id = wikilink_content:sub(1, pipe_pos - 1)
		local display = wikilink_content:sub(pipe_pos + 1)
		return id, display, text:match("(%[%[.-%]%])")
	else
		return wikilink_content, wikilink_content, text:match("(%[%[.-%]%])")
	end
end

local function resolve_link(id, cache, quarto_prefix)
	local normalized_id = slug_normalize(id)
	if cache[normalized_id] then
		return cache[normalized_id], normalized_id
	end
	local f = io.open(quarto_prefix .. id .. ".qmd", "r")
	if f then
		f:close()
		return id, normalized_id
	end
	return nil, normalized_id
end

-- Process a single wikilink text and return link or nil
local function process_wikilink(wikilink_text, cache, quarto_prefix, link_prefix)
	local id, display = parse_wikilink(wikilink_text)
	if not id then
		return nil
	end

	local target_file = resolve_link(id, cache, quarto_prefix)
	if target_file then
		local link_path = link_prefix .. target_file .. ".qmd"
		return pandoc.Link(pandoc.Str(display), link_path)
	else
		io.stderr:write(string.format("[WARNING] Wikilink: link %s not found\n", id))
		return pandoc.Str(display)
	end
end

-- Process inlines list, combining Str elements and resolving wikilinks
-- This handles cases where | or spaces in wikilinks split the content across Str elements
local function process_inlines(inlines)
	local quarto_prefix = get_quarto_prefix()
	local link_prefix = quarto_prefix
	local cache = build_title_cache(quarto_prefix)

	local result = {}
	local i = 1

	while i <= #inlines do
		local inline = inlines[i]

		if inline.t == "Str" and inline.text:find("%[%[") then
			-- Found start of wikilink
			-- Check if the wikilink is complete in this single Str
			local end_pos = inline.text:find("%]%]")
			if end_pos then
				-- Complete wikilink in one Str, process it
				local wikilink_text = inline.text:sub(inline.text:find("%[%["), end_pos + 1)
				local processed = process_wikilink(wikilink_text, cache, quarto_prefix, link_prefix)
				if processed then
					table.insert(result, processed)
					-- Check if there's trailing text after the wikilink
					if end_pos + 2 <= #inline.text then
						local trailing = inline.text:sub(end_pos + 2)
						table.insert(result, pandoc.Str(trailing))
					end
				else
					table.insert(result, inline)
				end
				i = i + 1
			else
				-- Incomplete wikilink - need to collect subsequent elements
				local wikilink_parts = { inline.text }
				local j = i + 1
				local found_end = false

				-- Collect Str and Space elements until we find ]]
				while j <= #inlines do
					local next_inline = inlines[j]
					if next_inline.t == "Str" then
						table.insert(wikilink_parts, next_inline.text)
						if next_inline.text:find("%]%]") then
							found_end = true
							break
						end
					elseif next_inline.t == "Space" then
						-- Spaces within the wikilink should be preserved (display text can have spaces)
						table.insert(wikilink_parts, " ")
					else
						-- Other non-text elements break the wikilink
						break
					end
					j = j + 1
				end

				if found_end then
					-- We have a complete wikilink, process it
					local full_text = table.concat(wikilink_parts)
					local processed = process_wikilink(full_text, cache, quarto_prefix, link_prefix)
					if processed then
						table.insert(result, processed)
					else
						-- Invalid wikilink, add parts as regular text (reconstructing spaces)
						for k, part in ipairs(wikilink_parts) do
							if part == " " then
								table.insert(result, pandoc.Space())
							else
								table.insert(result, pandoc.Str(part))
							end
						end
					end
					i = j + 1 -- Skip all consumed elements
				else
					-- Incomplete wikilink (no ]]), just add the opening part
					table.insert(result, inline)
					i = i + 1
				end
			end
		else
			-- Not a Str with [[, just copy
			table.insert(result, inline)
			i = i + 1
		end
	end

	return result
end

-- Filter function for elements with inline content
local function process_inlines_elem(elem)
	elem.content = process_inlines(elem.content)
	return elem
end

-- Passthrough functions for code elements
local function code_passthrough(elem)
	return elem
end

return {
	{
		Para = process_inlines_elem,
		Plain = process_inlines_elem,
		Code = code_passthrough,
		CodeBlock = code_passthrough,
	},
}
