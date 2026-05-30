-- Convert GitHub/Obsidian-style callouts to Quarto callouts
-- Usage: Add to _quarto.yml:
--   filters:
--     - filters/callouts.lua

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

local VALID_TYPES = {
	note = "Note",
	warning = "Warning",
	important = "Important",
	tip = "Tip",
	caution = "Caution",
}

local function create_callout_div(content, callout_type, title)
	callout_type = callout_type:lower()

	if not has_key(VALID_TYPES, callout_type) then
		return nil
	end

	local display_title = (title and title ~= "") and title or VALID_TYPES[callout_type]

	local header = pandoc.Div({
		pandoc.RawInline("html", '<div class="callout-icon-container"><i class="callout-icon"></i></div>'),
		pandoc.RawInline(
			"html",
			string.format('<div class="callout-title-container flex-fill">%s</div>', display_title)
		),
	}, pandoc.Attr("", { "callout-header", "d-flex", "align-content-center" }))

	local body = pandoc.Div(content, pandoc.Attr("", { "callout-body-container", "callout-body" }))

	return pandoc.Div(
		{ header, body },
		pandoc.Attr("", {
			"callout",
			"callout-style-default",
			"callout-" .. callout_type,
			"callout-titled",
		})
	)
end

local function BlockQuote(el)
	local first_para = el.content[1]
	if not first_para or first_para.t ~= "Para" then
		return el
	end

	local first_elem = first_para.content[1]
	if not first_elem or first_elem.t ~= "Str" then
		return el
	end

	-- Match [!TYPE] at start of first Str
	local callout_type = first_elem.text:match("^%[!(%w+)%]$")
	if not callout_type then
		return el
	end

	callout_type = callout_type:lower()

	-- Remove the marker
	first_para.content:remove(1)

	-- Check if there's a custom title (Space followed by text before SoftBreak)
	local title = ""
	local title_elements = {}
	local i = 1

	-- Skip initial space if present
	if first_para.content[i] and first_para.content[i].t == "Space" then
		i = i + 1
	end

	-- Collect title elements until we hit a SoftBreak or end
	while i <= #first_para.content do
		local elem = first_para.content[i]
		if elem.t == "SoftBreak" then
			break
		end
		table.insert(title_elements, elem)
		i = i + 1
	end

	-- Build title from collected elements
	if #title_elements > 0 then
		-- Create temporary paragraph to stringify title elements
		local temp_para = pandoc.Para(title_elements)
		title = pandoc.utils.stringify(temp_para)
		title = trim(title)

		-- Remove title elements and the SoftBreak from first paragraph
		for j = 1, #title_elements + 1 do -- +1 for the SoftBreak
			if #first_para.content > 0 then
				first_para.content:remove(1)
			end
		end
	else
		-- No title, just remove the SoftBreak if present
		if first_para.content[1] and first_para.content[1].t == "SoftBreak" then
			first_para.content:remove(1)
		end
	end

	-- Remove first paragraph if empty
	if #first_para.content == 0 then
		el.content:remove(1)
	end

	-- Create callout
	local callout = create_callout_div(el.content, callout_type, title)
	return callout or el
end

-- Passthrough functions for code elements
local function code_passthrough(elem)
	return elem
end

return {
	{ BlockQuote = BlockQuote, Code = code_passthrough, CodeBlock = code_passthrough },
}
