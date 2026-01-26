return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Mason: Package manager for LSP servers, formatters, linters
		-- Run :Mason to see installed tools and install new ones
		{ "mason-org/mason.nvim", opts = {} },
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Fidget: Shows LSP progress in the bottom right corner
		{ "j-hui/fidget.nvim", opts = {} },

		-- Blink: Provides enhanced completion capabilities to LSP
		"saghen/blink.cmp",
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				-- Helper function to create buffer-local keymaps
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- Navigation keybindings (all start with 'g' for "go")
				map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

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

		-- Diagnostic Configuration
		-- Diagnostics are the errors, warnings, and hints shown by LSP
		-- See :help vim.diagnostic.Opts

		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
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

		-- LSP Capabilities
		-- Tell language servers what features Neovim supports
		-- blink.cmp adds extra completion capabilities
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- Language Server Configuration
		-- Each entry in this table configures a specific language server
		-- See :help lspconfig-all for available servers

		local servers = {
			-- R Language Server
			-- Provides: completion, go-to-definition for R code
			-- NOTE: Diagnostics ARE enabled, but style warnings disabled via ~/.lintr.
			-- Formatting is by air
			r_language_server = {
				filetypes = { "r" },
				settings = {
					r = {
						lsp = {
							server_capabilities = {
								documentFormattingProvider = false,
								documentRangeFormattingProvider = false,
							},
						},
					},
				},
			},

			-- Lua Language Server
			-- Provides: completion, diagnostics, formatting for Lua code
			-- Used when editing Neovim config files
			lua_ls = {
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						diagnostics = { disable = { "missing-fields", "undefined-global" } },
					},
				},
			},
		}

		-- Mason Setup
		-- ==========================================================================
		-- Automatically install configured language servers and tools
		-- Run :Mason to see the UI and manage installations

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua", -- Lua formatter
			"air", -- R formatter from Posit
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		-- Connect mason-lspconfig to set up each server
		require("mason-lspconfig").setup({
			ensure_installed = {}, -- mason-tool-installer handles this
			automatic_installation = false,
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					-- Merge our capabilities with any server-specific ones
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}
