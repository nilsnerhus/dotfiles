-- FEAT: Add some kind of message everytime a languageserver is started. Or where has the fidget gone?
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"j-hui/fidget.nvim",
		"saghen/blink.cmp",
	},
	config = function()
		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			signs = vim.g.have_nerd_font and {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
				},
			} or {},
			virtual_text = {
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					return diagnostic.message
				end,
			},
		})

		-- Tell language servers what features Neovim supports
		-- blink.cmp adds extra completion capabilities
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		vim.lsp.config("marksman", {
			cmd = { "marksman", "server" },
			filetypes = { "markdown", "quarto" },
			root_markers = { ".git", ".marksman.toml" },
			capabilities = capabilities,
		})

		-- R Language Server: Handles .r files
		-- Set library path before loading languageserver
		local r_lib = vim.fn.expand("~/R/x86_64-pc-linux-gnu-library/4.5")
		vim.lsp.config("r_language_server", {
			cmd = {
				"sh",
				"-c",
				"R --no-echo -e '.libPaths(c(\"" .. r_lib .. "\", .libPaths())); languageserver::run()'",
			},
			filetypes = { "r" },
			root_markers = { ".git" },
			capabilities = capabilities,
		})

		-- Lua Language Server: Handles Neovim config files
		vim.lsp.config("lua_ls", {
			cmd = { "lua-language-server" },
			filetypes = { "lua" },
			root_markers = { ".git" },
			capabilities = capabilities,
		})

		-- Enable all servers defined with vim.lsp.config() above
		vim.lsp.enable({
			"marksman",
			"r_language_server",
			"lua_ls",
		})

		-- Runs when an LSP client attaches to a buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				-- Helper function to create buffer-local keymaps
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- Navigation keybindings (all start with 'g' for "go")
				map("grd", require("telescope.builtin").lsp_definitions, "[G]o to [D]efinition")
				map("grD", vim.lsp.buf.declaration, "[G]o to [D]eclaration")
				map("grr", require("telescope.builtin").lsp_references, "[G]o to [R]eferences")
				map("gri", require("telescope.builtin").lsp_implementations, "[G]o to [I]mplementation")
				map("grt", require("telescope.builtin").lsp_type_definitions, "[G]o to [T]ype Definition")

				-- Symbol search
				map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
				map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")

				-- Code modification
				map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

				-- Highlight references under cursor
				-- When your cursor rests on a symbol, all other uses of that symbol
				-- in the file are highlighted. Helps you see where variables are used.

				---@param client vim.lsp.Client
				---@param method vim.lsp.protocol.Method
				---@param bufnr? integer
				---@return boolean
				local function client_supports_method(client, method, bufnr)
					if vim.fn.has("nvim-0.11") == 1 then
						return client:supports_method(method, bufnr)
					else
						return client.supports_method(method, { bufnr = bufnr })
					end
				end

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if
					client
					and client_supports_method(
						client,
						vim.lsp.protocol.Methods.textDocument_documentHighlight,
						event.buf
					)
				then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })

					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end
			end,
		})
	end,
}
