-- =============================================================================
-- Telescope Notes Extension
-- =============================================================================
-- Custom Telescope extension for note-taking workflow with YAML frontmatter
-- support. Enables wiki-link insertion and enhanced file finding with titles.
--
-- Features:
-- - Extracts titles from YAML frontmatter in .md and .qmd files
-- - Displays "Title (filename)" format in Telescope picker
-- - Inserts wiki-links in format: [[filename|Title]] (without extension)
-- - Searches both title and filename for better discovery
--
-- Usage:
--   :Telescope notes find_files    " Find files with title display
--   :Telescope notes wiki_link     " Insert wiki-link (called from [[ keybind)
--
-- In config:
--   require("telescope").extensions.notes.find_files()
--   require("telescope").extensions.notes.wiki_link()

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")

-- =============================================================================
-- Helper Functions
-- =============================================================================

-- Extract title from YAML frontmatter
-- Looks for 'title:' field at the beginning of a file
-- Returns: title string or nil
local function extract_title(filepath)
	local file = io.open(filepath, "r")
	if not file then
		return nil
	end

	local content = file:read("*a")
	file:close()

	-- Check if file starts with --- (YAML frontmatter)
	if not content:match("^---") then
		return nil
	end

	-- Extract the title field from frontmatter
	-- Match: title: "value" or title: value
	local title = content:match("title:%s*['\"]?([^'\"\n]+)['\"]?")

	if title then
		-- Clean up whitespace and quotes
		title = title:gsub("^%s+", ""):gsub("%s+$", "")
		return title
	end

	return nil
end

-- Strip file extension from filename
-- Returns: filename without .md or .qmd extension
local function strip_extension(filename)
	return filename:gsub("%.qmd$", ""):gsub("%.md$", "")
end

-- Format display string for a file entry
-- Returns: table with display, ordinal, and title
local function format_entry(filepath)
	local filename = vim.fn.fnamemodify(filepath, ":t")
	local filename_no_ext = strip_extension(filename)

	-- Only extract title for .md and .qmd files
	local ext = vim.fn.fnamemodify(filepath, ":e")
	if ext == "md" or ext == "qmd" then
		local title = extract_title(filepath)
		if title and title ~= "" then
			-- Display: "Title (filename)"
			-- Ordinal: "Title filename" (for searching by both)
			return {
				display = title .. " (" .. filename .. ")",
				ordinal = title .. " " .. filename,
				title = title,
				filename_no_ext = filename_no_ext,
			}
		end
	end

	-- Fallback: just filename
	return {
		display = filename,
		ordinal = filename,
		title = filename_no_ext,
		filename_no_ext = filename_no_ext,
	}
end

-- Create entry maker for Telescope pickers
-- Returns: function that transforms filepaths into displayable entries
local function create_entry_maker()
	return function(filepath)
		local formatted = format_entry(filepath)

		return {
			value = filepath,
			display = formatted.display,
			ordinal = formatted.ordinal,
			path = filepath,
			title = formatted.title,
			filename_no_ext = formatted.filename_no_ext,
		}
	end
end

-- =============================================================================
-- Picker Functions
-- =============================================================================

-- Enhanced find_files with title support from YAML frontmatter
-- Shows "Title (filename)" in picker, searches both title and filename
local function find_files_with_titles(opts)
	opts = opts or {}

	builtin.find_files({
		cwd = opts.cwd,
		hidden = opts.hidden or true,
		previewer = conf.file_previewer(opts),
		sorter = conf.generic_sorter(opts),
		prompt_title = opts.prompt_title or "Find Notes",
		entry_maker = create_entry_maker(),
	})
end

-- Wiki-link picker: Select a file and insert [[filename|Title]] link
-- Triggered by [[ in markdown/quarto files via autocmd
local function wiki_link_picker(opts)
	opts = opts or {}

	-- Get current directory for search scope
	local cwd = opts.cwd or vim.fn.getcwd()

	builtin.find_files({
		cwd = cwd,
		hidden = opts.hidden or true,
		previewer = conf.file_previewer(opts),
		sorter = conf.generic_sorter(opts),
		prompt_title = "Insert Wiki-link",
		entry_maker = create_entry_maker(),

		attach_mappings = function(prompt_bufnr, map)
			-- Override default action to insert wiki link instead of opening file
			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
				if selection then
					actions.close(prompt_bufnr)

					-- Extract data from selection
					local filename_no_ext = selection.filename_no_ext
					local title = selection.title

					-- Format wiki link: [[filename|Title]]
					local wiki_link = string.format("[[%s|%s]]", filename_no_ext, title)

					-- Delete the [[ that was typed
					-- Using feedkeys in normal mode to handle the deletion properly
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<BS><BS>", true, false, true), "n", true)

					-- Insert the wiki link at cursor position
					vim.api.nvim_put({ wiki_link }, "", false, true)
				end
			end)

			return true
		end,
	})
end

-- =============================================================================
-- Extension Registration
-- =============================================================================

return require("telescope").register_extension({
	setup = function(ext_config, config)
		-- Extension configuration (currently none needed)
		-- Could add: default search directories, custom title patterns, etc.
	end,

	exports = {
		-- Primary pickers
		find_files = find_files_with_titles,
		wiki_link = wiki_link_picker,

		-- Aliases for convenience
		notes = find_files_with_titles, -- :Telescope notes notes
	},
})
