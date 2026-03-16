-- LSP configuration
vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	signs = vim.g.have_nerd_font and {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
	} or {},
	virtual_text = {
		source = "if_many",
		spacing = 2,
		format = function(d)
			return d.message
		end,
	},
})

local capabilities = require("blink.cmp").get_lsp_capabilities()
local servers = {
	"marksman",
	"r_language_server",
	"lua_ls",
	"pyright",
}

for _, server in ipairs(servers) do
	local config = dofile(vim.fn.stdpath("config") .. "/lsp/" .. server .. ".lua")
	config.capabilities = capabilities
	vim.lsp.config(server, config)
end

vim.lsp.enable(servers)

-- FEAT: I don't really know why, but this is the full config from my reference. It doesn't do anything close to the things happening in this config
-- vim.lsp.enable({
--   "bashls",
--   "gopls",
--   "lua_ls",
--   "texlab",
--   "ts_ls",
--   "rust-analyzer",
--   -- "helm_ls",
--   "yamlls",
--   "pyright",
-- })
--
-- vim.diagnostic.config({ signs = true })
