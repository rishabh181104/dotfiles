local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("v", "jk", "<Esc>")

map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>h", ":nohlsearch<CR>", opts)
map("n", "<leader>e", ":Neotree toggle<CR>", opts)
map("n", "<leader>f", ":Telescope find_files<CR>", opts)
map("n", "<leader>r", ":Telescope live_grep<CR>", opts)

map("n", "<leader>sv", "<C-w>v", opts)
map("n", "<leader>sh", "<C-w>s", opts)
map("n", "<leader>se", "<C-w>=", opts)
map("n", "<leader>sx", ":close<CR>", opts)

map("n", "<leader>bn", ":bnext<CR>", opts)
map("n", "<leader>bp", ":bprevious<CR>", opts)
map("n", "<leader>bd", ":bd<CR>", opts)

map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts) -- Go to definition
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts) -- References
map("n", "gi", "<cmh>lua vim.lsp.buf.implementation()<CR>", opts) -- Go to implementation
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts) -- Hover documentation
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts) -- Rename symbol
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts) -- Code actions
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts) -- Format code

-- Diagnostics
map("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts) -- Previous diagnostic
map("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts) -- Next diagnostic
map("n", "<leader>dl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts) -- Open diagnostic float
map("n", "<leader>ds", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts) -- Set location list

-- Harpoon
map("n", "<leader>ha", ":lua require('harpoon.mark').add_file()<CR>", opts) -- Add file to Harpoon
map("n", "<leader>hm", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", opts) -- Open Harpoon menu
map("n", "<leader>hn", ":lua require('harpoon.ui').nav_next()<CR>", opts) -- Navigate to next Harpoon mark
map("n", "<leader>hp", ":lua require('harpoon.ui').nav_prev()<CR>", opts) -- Navigate to previous Harpoon mark

-- LuaSnip
map("i", "<C-K>", "<cmd>lua require('luasnip').expand_or_jump()<CR>", opts) -- Expand or jump in snippet
map("i", "<C-J>", "<cmd>lua require('luasnip').jump(-1)<CR>", opts) -- Jump back in snippet

-- Treesitter
map("n", "<leader>th", ":TSHighlightCapturesUnderCursor<CR>", opts) -- Highlight Treesitter group under cursor
map("n", "<leader>ti", ":TSPlaygroundToggle<CR>", opts) -- Toggle Treesitter Playground

-- Neo-tree
map("n", "<leader>e", ":Neotree toggle<CR>", opts) -- Toggle Neo-tree

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>", opts) -- Find files
map("n", "<leader>fg", ":Telescope live_grep<CR>", opts) -- Live grep
map("n", "<leader>fb", ":Telescope buffers<CR>", opts) -- Find buffers
map("n", "<leader>fh", ":Telescope help_tags<CR>", opts) -- Help tags

-- Extra Keybinds
map("n", "<leader>tt", ":Telescope<CR>", opts) -- Open Telescope
map("n", "<leader>xx", ":source %<CR>", opts) -- Source current file
map("n", "<leader>pp", ":Lazy<CR>", opts) -- Open Lazy plugin manager
