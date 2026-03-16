-- Wikilinks Filter for Quarto
-- Converts Obsidian-style [[id]] and [[id|display]] wikilinks to Markdown links
-- Uses marksman-compatible slug normalization for title-based links
-- Shows warnings for broken links and renders them as plain text

-- Global cache for title-to-filename mapping
local title_cache = nil

-- Marksman-compatible slug normalization
-- Based on: https://github.com/artempyanykh/marksman/blob/main/Marksman/Misc.fs
local function slug_normalize(text)
	if not text or text == "" then
		return ""
	end

	-- Trim whitespace
	text = text:match("^%s*(.-)%s*$")

	local result = {}
	local sep_seen = false
	local chunk_state = 0 -- 0: no text, 1: in chunk, 2: finished chunk

	for i = 1, #text do
		local char = text:sub(i, i)
		local byte = string.byte(char)

		-- Check if character is punctuation or symbol
		local is_punct = char:match("[%^%$%(%)%%%.%[%]%*%+%-%?%%]")
			or (byte >= 33 and byte <= 47 and byte ~= 45)
			or (byte >= 58 and byte <= 64)
			or (byte >= 91 and byte <= 96 and byte ~= 95)
			or (byte >= 123 and byte <= 126)

		-- Check if separator (whitespace or hyphen)
		local is_sep = char:match("%s") or char == "-"

		-- Check if this is a character to output
		local is_to_out = not is_punct and not is_sep

		if is_sep then
			sep_seen = true
		end

		if is_to_out then
			if sep_seen and chunk_state == 2 then
				table.insert(result, "-")
				sep_seen = false
			end

			chunk_state = 1
			table.insert(result, char:lower())
		elseif chunk_state == 1 then
			chunk_state = 2
		end
	end

	return table.concat(result)
end

-- Extract H1 title from file content
local function extract_h1_title(content)
	if not content then
		return nil
	end

	-- Skip frontmatter (YAML between --- delimiters)
	local pos = 1
	if content:sub(1, 3) == "---" then
		local end_pos = content:find("\n---", 4)
		if end_pos then
			pos = end_pos + 4
		end
	end

	-- Look for first H1 heading
	for line in content:sub(pos):gmatch("[^\n]+") do
		local title = line:match("^%s*#%s+(.+)$")
		if title then
			return title:match("^%s*(.-)%s*$") -- Trim whitespace
		end
	end

	return nil
end

-- Build title-to-filename lookup table
local function build_title_cache(src_prefix)
	if title_cache then
		return title_cache
	end

	title_cache = {}

	-- Scan all .qmd files
	local handle = io.popen("ls -1 " .. src_prefix .. "*.qmd 2>/dev/null")
	if handle then
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
							title_cache[slug] = filename
						end
					end
				end
			end
		end
		handle:close()
	end

	return title_cache
end

-- Parse wikilink: [[id|display]] or [[id]]
local function parse_wikilink(text)
	local content = text:match("^%[%[(.+)%]%]$")
	if not content then
		return nil, nil
	end

	local pipe_pos = content:find("|")
	if pipe_pos then
		local id = content:sub(1, pipe_pos - 1)
		local display = content:sub(pipe_pos + 1)
		return id, display
	else
		return content, content
	end
end

-- Build inlines with resolved wikilinks
local function build_inlines(text)
	local inlines = {}
	local last_pos = 1

	-- Get current working directory
	local cwd_handle = io.popen("pwd")
	local cwd = cwd_handle:read("*line")
	cwd_handle:close()

	-- Determine if we're in src/ directory and set prefixes accordingly
	local is_in_src_dir = cwd:match("/src$") or cwd:match("/src/")
	local src_prefix = is_in_src_dir and "" or "src/"
	local link_prefix = is_in_src_dir and "" or "src/"

	-- Build title cache with appropriate prefix
	local cache = build_title_cache(src_prefix)

	while true do
		local start_pos = text:find("%[%[", last_pos)
		if not start_pos then
			break
		end

		local end_pos = text:find("%]%]", start_pos)
		if not end_pos then
			break
		end

		-- Add text before wikilink
		local before_text = text:sub(last_pos, start_pos - 1)
		if before_text ~= "" then
			table.insert(inlines, pandoc.Str(before_text))
		end

		-- Extract wikilink
		local wikilink = text:sub(start_pos, end_pos + 1)
		local id, display = parse_wikilink(wikilink)

		if id then
			local found = false
			local target_file = nil

			-- First, try to find by title (normalize the id to slug)
			local normalized_id = slug_normalize(id)
			if cache[normalized_id] then
				target_file = cache[normalized_id]
				found = true
			end

			-- If not found by title, check if it's a direct filename reference
			if not found then
				local f = io.open(src_prefix .. id .. ".qmd", "r")
				if f then
					f:close()
					target_file = id
					found = true
				end
			end

			if found and target_file then
				-- Create Pandoc Link with appropriate path
				local link_path = link_prefix .. target_file .. ".qmd"
				local link = pandoc.Link(pandoc.Str(display), link_path)
				table.insert(inlines, link)
			else
				-- File not found - show warning and render as text
				io.stderr:write("[Warning]: Wikilink target not found: " .. id .. "\n")
				table.insert(inlines, pandoc.Str(display))
			end
		else
			-- Malformed wikilink, keep as-is
			table.insert(inlines, pandoc.Str(wikilink))
		end

		last_pos = end_pos + 2
	end

	-- Add remaining text
	local remaining = text:sub(last_pos)
	if remaining ~= "" then
		table.insert(inlines, pandoc.Str(remaining))
	end

	return inlines
end

-- Process Str elements (text strings)
function Str(elem)
	if elem.text:find("%[%[") then
		local inlines = build_inlines(elem.text)
		return pandoc.Span(inlines)
	end
	return elem
end

-- Don't process code elements (inline code)
function Code(elem)
	return elem
end

-- Don't process code blocks
function CodeBlock(elem)
	return elem
end

-- Main filter
return {
	{ Str = Str, Code = Code, CodeBlock = CodeBlock },
}
