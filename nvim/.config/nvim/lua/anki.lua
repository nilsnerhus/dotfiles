local utils = require("utils")
local M = {}

-- Client

local function request(action, params)
	local body = vim.json.encode({ action = action, params = params or {}, version = 6 })
	local result = vim.system({ "curl", "-s", "-X", "POST", "-d", body, "http://127.0.0.1:8765" }, { text = true })
		:wait()
	if result.code ~= 0 then
		local err_msg = result.stderr and tostring(result.stderr) or ("curl failed with code " .. result.code)
		return nil, err_msg
	end
	if not result.stdout or result.stdout == "" then
		return nil, "empty response from AnkiConnect"
	end
	local ok, response = pcall(vim.json.decode, result.stdout)
	if not ok then
		return nil, "invalid JSON response"
	end
	if response.error and response.error ~= vim.NIL then
		return nil, tostring(response.error)
	end
	return response.result
end

local function to_html(text)
	return text:gsub("\n", "<br>")
end

local function ensure_deck(deck_name)
	local result, err = request("createDeck", { deck = deck_name })
	if err then
		return nil, err
	end
	return result
end

local function add_card(deck_name, front, back)
	local result, err = request("addNote", {
		note = {
			deckName = deck_name,
			modelName = "Basic (and reversed card)",
			fields = { Front = front, Back = back },
		},
	})
	if err then
		return nil, err
	end
	return result
end

local function add_cloze_card(deck_name, text)
	local result, err = request("addNote", {
		note = {
			deckName = deck_name,
			modelName = "Cloze",
			fields = { Text = text, ["Back Extra"] = "" },
		},
	})
	if err then
		return nil, err
	end
	return result
end

local function delete_cards(note_ids)
	if #note_ids == 0 then
		return
	end
	local result, err = request("deleteNotes", { notes = note_ids })
	if err then
		return nil, err
	end
	return result
end

-- State

local function read_state(path)
	local f = io.open(path, "r")
	if not f then
		return {}
	end
	local content = f:read("*a")
	f:close()
	local ok, state = pcall(vim.json.decode, content)
	if not ok then
		return {}
	end
	return state or {}
end

local function pretty_json(value, indent)
	indent = indent or 0
	local spacing = string.rep("  ", indent)
	local next_spacing = string.rep("  ", indent + 1)

	if type(value) == "table" then
		local is_array = #value > 0 or next(value) == nil

		if is_array then
			if #value == 0 then
				return "[]"
			end
			local items = {}
			for _, v in ipairs(value) do
				table.insert(items, next_spacing .. pretty_json(v, indent + 1))
			end
			return "[\n" .. table.concat(items, ",\n") .. "\n" .. spacing .. "]"
		else
			local items = {}
			for k, v in pairs(value) do
				table.insert(items, next_spacing .. '"' .. k .. '": ' .. pretty_json(v, indent + 1))
			end
			table.sort(items)
			return "{\n" .. table.concat(items, ",\n") .. "\n" .. spacing .. "}"
		end
	elseif type(value) == "string" then
		return '"'
			.. value:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n"):gsub("\r", "\\r"):gsub("\t", "\\t")
			.. '"'
	elseif type(value) == "number" or type(value) == "boolean" then
		return tostring(value)
	elseif value == nil then
		return "null"
	else
		return '"' .. tostring(value) .. '"'
	end
end

local function write_state(path, state)
	local f = io.open(path, "w")
	if f then
		f:write(pretty_json(state))
		f:close()
	end
end

-- Sync

function M.sync(deck_name, new_cards)
	local ctx = utils.file_context("md", "anki")
	local path = ctx.dir .. "/anki.json"

	local state = read_state(path)
	local old_cards = state[deck_name] or {}

	local prepared = {}
	local matched_old_indices = {}

	for _, new_card in ipairs(new_cards) do
		local matched = vim.deepcopy(new_card)

		for idx, old_card in ipairs(old_cards) do
			if not matched_old_indices[idx] then
				local is_match = false
				if new_card.front and old_card.front == new_card.front and old_card.back == new_card.back then
					is_match = true
				elseif new_card.text and old_card.text == new_card.text then
					is_match = true
				end

				if is_match then
					matched.note_id = old_card.note_id
					matched_old_indices[idx] = true
					break
				end
			end
		end

		table.insert(prepared, matched)
	end

	local deleted = {}
	for idx, old_card in ipairs(old_cards) do
		if not matched_old_indices[idx] and old_card.note_id then
			table.insert(deleted, old_card.note_id)
		end
	end

	state[deck_name] = prepared
	write_state(path, state)

	ensure_deck(deck_name)

	if #deleted > 0 then
		delete_cards(deleted)
	end

	local added = 0
	local final_cards = {}

	for _, card in ipairs(prepared) do
		local final_card = vim.deepcopy(card)

		if not card.note_id then
			local note_id
			if card.front then
				note_id = add_card(deck_name, to_html(card.front), to_html(card.back))
			else
				note_id = add_cloze_card(deck_name, to_html(card.text))
			end
			if note_id then
				final_card.note_id = note_id
				added = added + 1
			end
		end

		table.insert(final_cards, final_card)
	end

	state[deck_name] = final_cards
	write_state(path, state)

	local parts = {}
	if added > 0 then
		table.insert(parts, added .. " added")
	end
	if #deleted > 0 then
		table.insert(parts, #deleted .. " deleted")
	end
	if #parts == 0 then
		table.insert(parts, "all up to date")
	end

	vim.notify("Anki: " .. table.concat(parts, ", "), vim.log.levels.INFO)
end

return M
