local buffer_count = 0

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local zen = require("zen-mode")
		buffer_count = vim.fn.len(vim.fn.getbufinfo({ buflisted = 1 }))
		if buffer_count == 1 then
			zen.open()
		end

		vim.api.nvim_create_autocmd({ "BufEnter", "BufDelete", "BufWipeout" }, {
			callback = function()
				local new_count = vim.fn.len(vim.fn.getbufinfo({ buflisted = 1 }))

				if new_count ~= buffer_count then
					buffer_count = new_count

					if buffer_count == 1 then
						zen.open()
					elseif buffer_count > 1 then
						zen.close()
					end
				end
			end,
		})
	end,
})