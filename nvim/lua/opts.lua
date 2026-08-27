vim.g.mapleader = ";"
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.smartindent = true
vim.opt.list = true -- This is inverted because of the keymap
vim.opt.listchars = { space = '·', tab = '↹ ', eol = '⏎', trail='·'}

vim.opt.wrap = true
vim.opt.scrolloff = 8
vim.opt.fillchars = { eob = '┊'}

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = false

vim.opt.termguicolors = true
vim.opt.nu = true
vim.opt.rnu = true
vim.opt.signcolumn = "yes:3"
vim.opt.laststatus = 3

vim.opt.clipboard = "unnamedplus"
vim.opt.autocomplete = true
vim.opt.completeopt = {"menuone", "noselect", "popup"}
