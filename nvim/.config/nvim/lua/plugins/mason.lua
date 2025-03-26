-- Mason LSP Configuration
require("mason-lspconfig").setup({
	automatic_installation = {
		exclude = { "ocamllsp" }, -- Exclude ocamllsp from automatic installation
	},
	ensure_installed = {
		"rust_analyzer", -- Rust
		"gopls", -- Go
		"ts_ls", -- JavaScript/TypeScript
		"pyright",
		"html",
		"cssls",
		"lua_ls",
	},
})

-- LSP setup with custom on_attach and capabilities
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local function on_attach(client, bufnr)
	local opts = { buffer = bufnr }
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
	vim.keymap.set({ "n", "x" }, "<F3>", function()
		vim.lsp.buf.format({ async = true })
	end, opts)
end

require("mason-lspconfig").setup_handlers({
	function(server_name)
		lspconfig[server_name].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end,
})

-- Mason Null-LS Configuration
require("mason-null-ls").setup({
	automatic_installation = true, -- Enable automatic installation for Null-LS sources
	ensure_installed = {
		-- Formatters
		"black",
		"stylua",
		"prettier",
		"rustfmt",
		"gofumpt",
		-- Linters
		"flake8",
		"eslint_d",
	},
})

-- Null-LS Configuration
local null_ls = require("null-ls")

-- Null-LS sources
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	sources = {
		-- Formatters
		formatting.black,
		formatting.stylua,
		formatting.prettier,
		formatting.rustfmt,
		formatting.gofumpt,
		-- Linters
		diagnostics.flake8,
		diagnostics.eslint_d,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})
		end
	end,
})
