-- =============================================================================
-- FileType Autocmds
-- =============================================================================
-- These autocmds run when specific filetypes are detected
-- See :help FileType and :help autocmd

-- =============================================================================
-- Markdown & Quarto: Note-taking and linking
-- =============================================================================
-- Wiki-link insertion system for note-taking workflow
-- Works in both .md and .qmd files for consistency
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "quarto" },
	group = vim.api.nvim_create_augroup("markdown-quarto-notes", { clear = true }),
	desc = "Setup note-linking keybinds for markdown and quarto files",
	callback = function()
		-- Wiki-link picker: Type [[ to open Telescope picker for note linking
		-- Inserts links in format: [[filename|Title]]
		vim.keymap.set("i", "[[", function()
			require("telescope").extensions.notes.wiki_link()
		end, {
			buffer = true,
			desc = "Insert wiki-link to another note",
			silent = true,
		})

		-- Follow wiki-link under cursor with gf
		-- Extracts [[filename|...]] and opens the file
		vim.keymap.set("n", "gf", function()
			-- Get the current line and cursor position
			local line = vim.api.nvim_get_current_line()
			local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- Lua is 1-indexed for string operations

			-- Find wiki-link pattern [[filename|...]] around cursor
			-- Pattern: [[anything|anything]] or [[anything]]
			local link_pattern = "%[%[([^%]|]+)"
			local start_pos = 1

			while true do
				local link_start, link_end, filename = line:find(link_pattern, start_pos)
				if not link_start then
					-- No wiki-link found, fall back to default gf behavior
					vim.cmd("normal! gf")
					return
				end

				-- Check if cursor is within this link
				if col >= link_start and col <= link_end + 2 then -- +2 for the closing ]]
					-- Found the link under cursor
					-- Try to find file with .qmd or .md extension
					local search_paths = {
						filename .. ".qmd",
						filename .. ".md",
					}

					-- Search recursively from current working directory
					local cwd = vim.fn.getcwd()
					for _, search_file in ipairs(search_paths) do
						local cmd = string.format("find %s -name %s -type f 2>/dev/null", vim.fn.shellescape(cwd), vim.fn.shellescape(search_file))
						local handle = io.popen(cmd)
						if handle then
							local result = handle:read("*a")
							handle:close()
							
							-- Get first match
							local filepath = result:match("([^\n]+)")
							if filepath and filepath ~= "" then
								vim.cmd("edit " .. vim.fn.fnameescape(filepath))
								return
							end
						end
					end

					-- If we get here, file wasn't found
					vim.notify("Wiki-link target not found: " .. filename, vim.log.levels.WARN)
					return
				end

				-- Move to next potential link
				start_pos = link_end + 1
			end
		end, {
			buffer = true,
			desc = "Follow wiki-link under cursor",
			silent = true,
		})

		-- Future keybinds can be added here:
		-- - <leader>nb for backlinks
		-- - etc.
	end,
})
