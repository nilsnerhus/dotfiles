local M = {
	active = false,
	augroup = vim.api.nvim_create_augroup("MoltenLivePreview", { clear = true }),
	original_cwd = nil,
	save_timer = nil,
}
local function run_all_cells()
	local runner = require("quarto.runner")
	local ok, err = pcall(runner.run_all)

	if not ok then
		vim.notify("Error running cells: " .. tostring(err), vim.log.levels.ERROR)
	end
end

-- Setup telescope integration
local function setup_telescope_integration()
	vim.api.nvim_create_autocmd("User", {
		group = M.augroup,
		pattern = "TelescopeFindPre",
		callback = function()
			if M.active then
				vim.cmd("MoltenHideOutput")
			end
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = M.augroup,
		pattern = "TelescopePrompt",
		callback = function(args)
			vim.api.nvim_create_autocmd("BufLeave", {
				buffer = args.buf,
				once = true,
				callback = function()
					vim.defer_fn(function()
						if M.active then
							vim.cmd("MoltenShowOutput")
						end
					end, 50)
				end,
			})
		end,
	})
end

-- Setup save autocmd
local function setup_save_autocmd()
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = M.augroup,
		buffer = 0,
		callback = function()
			if not M.active then
				return
			end

			if M.save_timer then
				M.save_timer:stop()
			end

			M.save_timer = vim.defer_fn(function()
				run_all_cells()
				M.save_timer = nil
			end, 500)
		end,
	})
end

-- Clear all autocmds
local function clear_autocmds()
	vim.api.nvim_clear_autocmds({ group = M.augroup, buffer = 0 })
end

-- Toggle
function M.toggle()
	if M.active then
		-- Deactivate
		M.active = false
		clear_autocmds()

		-- Restore original working directory
		if M.original_cwd then
			vim.cmd("cd " .. vim.fn.fnameescape(M.original_cwd))
			M.original_cwd = nil
		end

		-- Deinitialize molten
		vim.cmd("MoltenDeinit")

		vim.notify("Live Preview: OFF", vim.log.levels.INFO)
	else
		-- Activate
		M.active = true

		-- Save current directory and change to file's directory
		M.original_cwd = vim.fn.getcwd()
		local file_dir = vim.fn.expand("%:p:h")
		vim.cmd("cd " .. vim.fn.fnameescape(file_dir))

		-- Setup autocmds
		setup_telescope_integration()
		setup_save_autocmd()

		-- Initialize kernel (prompts user to select)
		vim.cmd("MoltenInit")

		-- Run all cells after kernel is ready
		vim.api.nvim_create_autocmd("User", {
			group = M.augroup,
			pattern = "MoltenKernelReady",
			once = true,
			callback = function()
				vim.defer_fn(function()
					run_all_cells()
				end, 200)
			end,
		})

		vim.notify("Live Preview: ON (cwd: " .. file_dir .. ")", vim.log.levels.INFO)
	end
end

return {
	{
		"benlubas/molten-nvim",
		version = "^1.0.0",
		ft = { "python", "markdown", "quarto", "r" },
		init = function()
			-- Molten configuration for floating windows
			vim.g.molten_output_win_max_height = 20
			vim.g.molten_output_virt_lines = false -- Use floating windows only
			vim.g.molten_virt_text_output = false
			vim.g.molten_auto_open_output = true
			vim.g.molten_enter_output_behavior = "open"
			vim.g.molten_wrap_output = true
			vim.g.molten_output_show_more = true
			vim.g.molten_output_win_border = "single"
		end,
		config = function()
			-- Keymaps
			local map = vim.keymap.set

			map("n", "<leader>tm", function()
				M.toggle()
			end, { desc = "[T]oggle [M]olten", silent = true })
		end,
	},
}
