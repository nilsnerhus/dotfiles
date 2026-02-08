return {
	{
		dir = vim.fn.stdpath("config"),
		name = "wsl-browser",
		lazy = false,
		cond = function()
			return vim.fn.has("wsl") == 1
		end,
		config = function()
			vim.ui.open = function(url)
				vim.fn.system({ "wsl-open", url })
			end
		end,
	},
}
