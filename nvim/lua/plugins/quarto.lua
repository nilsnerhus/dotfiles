-- Quarto integration for Neovim
-- Provides preview, code running, and LSP features for Quarto documents
--
-- Custom behavior:
-- - <leader>tq toggles Quarto preview (runs hidden, no terminal tab)
-- - First press starts preview, second press stops it

return {
	{
		"quarto-dev/quarto-nvim",
		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			local quarto = require("quarto")
			local util = require("quarto.util")
			local tools = require("quarto.tools")

			quarto.setup({
				debug = false,
				closePreviewOnExit = true,
				lspFeatures = {
					chunks = "curly",
					languages = { "r", "python" },
					completion = { enabled = true },
				},
				codeRunner = {
					enabled = true,
					default_method = "iron",
					never_run = { "yaml" },
				},
			})

			-- Track preview state
			local preview_job_id = nil

			-- Start preview in background (no visible terminal)
			local function start_preview()
				local buffer_path = vim.api.nvim_buf_get_name(0)

				-- Check file extension
				local quarto_extensions = { ".qmd", ".Rmd", ".ipynb", ".md" }
				local file_extension = buffer_path:match("^.+(%..+)$")
				if not file_extension then
					vim.notify("Not in a file", vim.log.levels.WARN)
					return
				end
				if not tools.contains(quarto_extensions, file_extension) then
					vim.notify("Not a Quarto file (ends in " .. file_extension .. ")", vim.log.levels.WARN)
					return
				end

				-- Find project root or use file
				local root_dir = util.root_pattern("_quarto.yml")(buffer_path)
				local cmd
				if root_dir then
					cmd = { "quarto", "preview", root_dir }
				else
					cmd = { "quarto", "preview", buffer_path }
				end

				-- Start the job in the background
				preview_job_id = vim.fn.jobstart(cmd, {
					on_exit = function(_, exit_code, _)
						if exit_code ~= 0 and exit_code ~= 143 then
							-- 143 = SIGTERM (normal kill), only notify on real errors
							vim.notify("Quarto preview exited with code " .. exit_code, vim.log.levels.ERROR)
						end
						preview_job_id = nil
					end,
				})

				if preview_job_id > 0 then
					vim.notify("Quarto preview started")
				else
					vim.notify("Failed to start Quarto preview", vim.log.levels.ERROR)
					preview_job_id = nil
				end
			end

			-- Stop preview
			local function stop_preview()
				if preview_job_id then
					vim.fn.jobstop(preview_job_id)
					preview_job_id = nil
					vim.notify("Quarto preview stopped")
				end
			end

			-- Toggle preview
			local function toggle_preview()
				if preview_job_id then
					stop_preview()
				else
					start_preview()
				end
			end

			-- Override the default QuartoPreview command to use our hidden version
			vim.api.nvim_create_user_command("QuartoPreview", function()
				start_preview()
			end, {})

			vim.api.nvim_create_user_command("QuartoClosePreview", function()
				stop_preview()
			end, {})

			-- Keybind: <leader>tq to toggle Quarto preview
			vim.keymap.set("n", "<leader>tq", toggle_preview, { desc = "Toggle Quarto preview" })
		end,
	},
}
