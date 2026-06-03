local M = {}

local utils = require("utils")

function M.create_new_note(template_path)
	local ctx = utils.dir_context("quarto")
	local hash = utils.generate_hash()
	local dest = ctx.dir .. "/" .. hash .. ".qmd"

	if template_path then
		vim.fn.system({ "cp", template_path, dest })
	end

	vim.cmd.edit(dest)
end

function M.create_note_from_template()
	local ctx = utils.dir_context("templates")
	local template_files = vim.fn.glob(ctx.dir .. "/*.qmd", false, true)
	if #template_files == 0 then
		vim.notify("No .qmd templates found in templates/", vim.log.levels.ERROR)
		error("No .qmd templates found in templates/", 0)
	end

	local template_names = {}
	for _, filepath in ipairs(template_files) do
		table.insert(template_names, vim.fn.fnamemodify(filepath, ":t"))
	end

	vim.ui.select(template_names, {
		prompt = "Select template:",
	}, function(choice, idx)
		if not choice then
			return
		end

		local template_path = template_files[idx]
		M.create_new_note(template_path)
		vim.notify("Created note from " .. choice, vim.log.levels.INFO)
	end)
end

function M.rehash_note()
	local ctx = utils.file_context("qmd", "src")

	local new_hash = utils.generate_hash()
	local new_filepath = ctx.dir .. "/" .. new_hash .. ".qmd"

	local choice = vim.fn.confirm("Rehash " .. ctx.filename .. " → " .. new_hash .. ".qmd?", "&Yes\n&No", 2)
	if choice ~= 1 then
		return
	end

	if vim.bo.modified then
		vim.cmd.write()
	end

	vim.fn.system("git mv " .. vim.fn.shellescape(ctx.filepath) .. " " .. vim.fn.shellescape(new_filepath))
	vim.cmd.edit(new_filepath)
	vim.notify("Rehashed: " .. ctx.filename .. " → " .. new_hash .. ".qmd", vim.log.levels.INFO)
end
return M
