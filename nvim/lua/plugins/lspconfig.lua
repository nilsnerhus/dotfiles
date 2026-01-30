-- LSP Configuration using Neovim 0.11+ vim.lsp.config() API
-- All servers are configured declaratively and enabled at once
-- Tool installations are managed in mason.lua

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Fidget: Shows LSP progress in the bottom right corner
		{ "j-hui/fidget.nvim", opts = {} },

		-- Blink: Provides enhanced completion capabilities to LSP
		"saghen/blink.cmp",

		-- Mason integration (kept for compatibility, may remove after testing)
		"mason-org/mason-lspconfig.nvim",
	},
	config = function()
		-- [[ Diagnostic Configuration ]]
		-- Diagnostics are the errors, warnings, and hints shown by LSP
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

		-- [[ LSP Capabilities ]]
		-- Tell language servers what features Neovim supports
		-- blink.cmp adds extra completion capabilities
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- [[ Server Configurations ]]
		-- Each server is configured declaratively using vim.lsp.config()

	-- Markdown LSP: Handles both .md and .qmd (quarto) files
	-- For quarto, this provides LSP for the main markdown document
	-- Code blocks are handled by Otter.nvim + r_language_server
	vim.lsp.config("markdown_oxide", {
		cmd = { "markdown-oxide" },
		filetypes = { "md", "qmd" },
		root_markers = { ".git", ".obsidian", ".moxide.toml" },
		root_dir = function(bufnr, on_dir)
			-- Find project root by searching for root_markers
			local root = vim.fs.root(bufnr, { ".git", ".obsidian", ".moxide.toml" })
			if root then
				on_dir(root)
			else
				-- Fallback: use current working directory if no root markers found
				on_dir(vim.loop.cwd())
			end
		end,
		capabilities = capabilities,
	})

	-- R Language Server: Handles .r files (including Otter virtual buffers)
	-- Does NOT attach to main .qmd files (Otter proxies code blocks)
	-- The root_dir function ensures we skip main quarto files
	vim.lsp.config("r_language_server", {
		cmd = { "R", "--no-echo", "-e", "languageserver::run()" },
		filetypes = { "r" },
		root_markers = { ".git" },
		root_dir = function(bufnr, on_dir)
			local fname = vim.api.nvim_buf_get_name(bufnr)
			-- Only process .r files, skip quarto files entirely
			if fname:match("%.qmd$") or fname:match("%.Qmd$") then
				return
			end
			-- Find git root or use home directory
			on_dir(vim.fs.root(bufnr, ".git") or vim.uv.os_homedir())
		end,
		capabilities = capabilities,
	})

	-- Lua Language Server: Handles Neovim config files
	vim.lsp.config("lua_ls", {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
				diagnostics = { disable = { "missing-fields", "undefined-global" } },
			},
		},
		capabilities = capabilities,
	})

		-- [[ Activate All Configured Servers ]]
		-- Enable all servers defined with vim.lsp.config() above
		-- vim.lsp.enable() automatically handles FileType autocommands internally,
		-- attaching servers when files with matching filetypes are opened
		vim.lsp.enable({ "markdown_oxide", "r_language_server", "lua_ls" })

		-- [[ LspAttach Autocommand ]]
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
