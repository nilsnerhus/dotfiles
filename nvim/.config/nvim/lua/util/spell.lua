local M = {}

function M.spell_picker()
	if not vim.o.spell then
		vim.notify("Spell checking is disabled. Toggle with <leader>ts", vim.log.levels.WARN)
		return
	end

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local make_entry = require("telescope.make_entry")

	-- Collect all misspelled words using vim.spell.check()
	local spell_items = {}
	local bufnr = vim.api.nvim_get_current_buf()
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	for row, line in ipairs(lines) do
		-- vim.spell.check() returns a list of {word, type, start_col, end_col}
		local spell_results = vim.spell.check(line)

		for _, result in ipairs(spell_results) do
			local word = result[1]
			local word_type = result[2]
			local start_col = result[3]
			local end_col = result[4]

			-- Only include bad words (type "bad"), not rare words or local words
			if word_type == "bad" or word_type == "rare" then
				local suggestions = vim.fn.spellsuggest(word, 5)
				local sugg_str = table.concat(suggestions, ", ")
				if sugg_str == "" then
					sugg_str = "No suggestions"
				end

				table.insert(spell_items, {
					filename = bufname,
					lnum = row,
					col = start_col + 1, -- Convert from 0-based to 1-based
					text = string.format('"%s" - %s', word, sugg_str),
				})
			end
		end
	end

	if #spell_items == 0 then
		vim.notify("No spelling errors found!", vim.log.levels.INFO)
		return
	end

	pickers
		.new({}, {
			prompt_title = "Spell Errors",
			finder = finders.new_table({
				results = spell_items,
				entry_maker = make_entry.gen_from_quickfix(),
			}),
			previewer = conf.grep_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end

return M
