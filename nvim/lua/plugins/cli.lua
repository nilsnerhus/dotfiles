-- CLI Framework Plugin
-- Tool-agnostic keybinding framework for sending code to various REPLs/tools
--
-- Usage:
--   s + motion → select tool → optional modifier → sends to tool
--   ss         → sends current line (prompts for tool)
--   visual s   → sends selection (prompts for tool)
--
-- Tools:
--   [o] OpenCode - AI assistant
--   [r] R REPL - via iron.nvim
--   [p] Python REPL - via iron.nvim

return {
	{
		dir = vim.fn.stdpath("config") .. "/lua/cli",
		name = "cli-framework",
		dependencies = {
			"Vigemus/iron.nvim", -- For R and Python REPLs
			"NickvanDyke/opencode.nvim", -- For OpenCode
		},
		config = function()
			local cli = require("cli")
			local registry = cli.registry

			-- Register OpenCode tool
			-- Uses opencode.nvim's ask() function
			registry.register("opencode", {
				id = "o",
				name = "OpenCode",
				send_fn = function(content, modifier)
					local opencode = require("opencode")
					if modifier == "a" then
						-- Ask mode: include @this context and submit immediately
						opencode.ask("@this: " .. content, { submit = true })
					else
						-- Default: just add content to the chat (don't auto-submit)
						opencode.ask(content)
					end
				end,
				modifiers = {
					a = { name = "Ask (auto-submit)" },
				},
			})

			-- Register R REPL tool
			-- Uses iron.nvim's send() function
			registry.register("rrepl", {
				id = "r",
				name = "R REPL",
				send_fn = function(content, modifier)
					local iron = require("iron.core")
					-- Convert content string to table of lines
					local lines = vim.split(content, "\n", { plain = true })
					iron.send("r", lines)
				end,
			})

			-- Register Python REPL tool
			-- Uses iron.nvim's send() function
			registry.register("python", {
				id = "p",
				name = "Python REPL",
				send_fn = function(content, modifier)
					local iron = require("iron.core")
					-- Convert content string to table of lines
					local lines = vim.split(content, "\n", { plain = true })
					iron.send("python", lines)
				end,
			})

			-- Initialize the CLI framework and set up keybindings
			cli.setup()
		end,
	},
}
