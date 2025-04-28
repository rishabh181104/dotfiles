local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim. Please check your internet connection or repository URL:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"theprimeagen/harpoon",
	{ "rose-pine/neovim", name = "rose-pine" },
	"nvim-lua/plenary.nvim",
	"nvim-telescope/telescope.nvim",
	"nvim-neo-tree/neo-tree.nvim",
	"nvim-tree/nvim-web-devicons",
	"MunifTanjim/nui.nvim",
	"rust-lang/rust.vim",
	-- Mason and LSP related plugins
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",
	"jay-babu/mason-null-ls.nvim",
	"jose-elias-alvarez/null-ls.nvim",
	"VonHeikemen/lsp-zero.nvim",

	-- Completion plugins
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
			"hrsh7th/cmp-buffer", -- Buffer completions
			"hrsh7th/cmp-path", -- Path completions
			"hrsh7th/cmp-cmdline", -- Command-line completions
			"saadparwaiz1/cmp_luasnip", -- Snippet completions
			"L3MON4D3/LuaSnip", -- Snippet engine
			"onsails/lspkind.nvim", -- Icons for completion items
		},
	},
	"rafamadriz/friendly-snippets",
	"L3MON4D3/LuaSnip",

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = true, -- Installs missing parsers only when needed
				highlight = { enable = true },
				indent = { enable = true },
				incremental_selection = { enable = true },
			})
		end,
	},

	-- Startify
	{
		"mhinz/vim-startify",
		config = function()
			vim.g.startify_custom_header = {
				"⠀⠀⠀⠀⢀⣠⠴⠒⠛⠋⠙⠛⠒⠦⣄⡀⠀⠀⠀⠀ ",
				"⠀⠀⣠⠞⠉⠀⠀⠀⠀⠀⠀⣀⡤⠀⣀⠉⠳⣄⠀  ",
				"⠀⡴⠃⠀⠀⠀⠀⣤⣤⣾⣿⣿⣿⣿⡉⠀⠀⠘⢦  ",
				"⣸⠁⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⠈⣇ ",
				"⡏⠀⠀⢀⠆⠀⠀⠀⣩⣽⣿⣟⣃⣠⠀⠀⠀⠀⠀⢹ ",
				"⡇⠀⠀⢸⠀⠀⠀⢠⣿⣿⣿⣯⣭⢽⡆⠀⠀⠀⠀⢸ ",
				"⢹⡀⠀⠈⠣⣀⣀⣼⣿⣿⣿⡍⠁⠀⠀⠀⠀⠀⢀⡏ ",
				"⠀⠳⡄⠀⠀⢿⣿⡿⠿⣿⣿⣿⣷⣄⠀⠀⠀⢠⠞⠀ ",
				"⠀⠀⠙⢦⣀⣨⣿⣅⣀⣀⣀⣉⣉⣻⣧⣀⡴⠋⠀⠀ ",
				"⠀⠀⠀⠀⠈⠛⠿⢿⣿⣿⣿⣿⡿⠿⠛⠁⠀⠀⠀⠀ ",
			}
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
})
