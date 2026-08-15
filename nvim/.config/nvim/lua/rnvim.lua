local function send_all_chunks()
	local chunk = require("r.chunk")
	local chunks = chunk.get_code_chunks(0)
	chunks = chunk.filter_code_chunks_by_eval(chunks)
	chunks = chunk.filter_supported_langs(chunks)

	if #chunks == 0 then
		require("r").warn("No evaluable supported code chunks found.")
		return
	end

	local lines = chunk.codelines_from_chunks(chunks)
	require("r.send").source_lines(lines)
end

local function on_filetype()
	-- Start/close R
	vim.api.nvim_buf_set_keymap(0, "n", "<localleader>rs", "<Plug>RStart", { desc = "[s]tart R" })
	vim.api.nvim_buf_set_keymap(0, "n", "<localleader>rq", "<Plug>RClose", { desc = "[q]uit R" })

	-- Send code
	vim.api.nvim_buf_set_keymap(0, "n", "<localleader>rl", "<Plug>RDSendLine", { desc = "run [l]ine" })
	vim.api.nvim_buf_set_keymap(0, "v", "<localleader>r", "<Plug>RSendSelection", { desc = "visual [r]ange" })
	vim.api.nvim_buf_set_keymap(0, "n", "<localleader>rc", "<Plug>RDSendChunk", { desc = "[c]ell" })
	vim.api.nvim_buf_set_keymap(0, "n", "<localleader>ra", "<Plug>RSendChunkFH", { desc = "cell [a]bove" })

	-- Object browser
	vim.api.nvim_buf_set_keymap(0, "n", "<localleader>ro", "<Plug>ROBToggle", { desc = "[o]bject browser" })

	-- Send all chunks in Quarto/Rmd documents
	if vim.tbl_contains({ "quarto", "rmd", "markdown" }, vim.bo.filetype) then
		vim.api.nvim_buf_set_keymap(0, "n", "<localleader>rA", "", {
			desc = "cell [A]ll",
			callback = send_all_chunks,
		})
	end
end

require("r").setup({
	user_maps_only = true,
	hook = {
		on_filetype = on_filetype,
	},
	R_args = { "--no-save", "--quiet" },
	r_ls = {
		completion = true,
		hover = true,
		signature = true,
		implementation = true,
		definition = true,
		references = true,
		document_highlight = true,
		document_symbol = true,
		workspace_symbol = true,
		rename = true,
	},
})
