-- ----------- --
-- NVIM CONFIG --
-- ----------- --
vim.opt.termguicolors = true -- make sure colors match with the terminal env

-- --------- --
-- LAZY.NVIM --
-- --------- --

-- INSTALL 
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
vim.fn.system({
"git", "clone", "--filter=blob:none",
"https://github.com/folke/lazy.nvim.git",
"--branch=stable", -- latest stable release
lazypath,
})
end
vim.opt.rtp:prepend(lazypath)

-- SETUP & PLUGINS
require("lazy").setup({

-- Completion and LSP
{
'saecki/crates.nvim',
tag = 'stable',
config = function()
require('crates').setup()
end,
},
{ 'neovim/nvim-lspconfig' },
{ 'mfussenegger/nvim-lint' },
{ 'mfussenegger/nvim-dap' },

-- Syntax & Highlighting
{ "nvim-treesitter/nvim-treesitter",
build = ":TSUpdate", -- keep automatically updated
config = function ()
local configs = require("nvim-treesitter.configs")

configs.setup({
ensure_installed = {"c", "lua", "rust", "html", "css", "javascript"},
sync_install = false,
highlight = { enable = true, use_languagetree = true },
indent = {enable = true},
})
end,
},

-- NVIM UI/UX
{ 'wpkelso/argonoct-neovim',
name        = 'argonoct',
lazy        = false,
priority    = 1000, -- load as early as possible
},
{ "nvim-lualine/lualine.nvim", lazy = false },
{ "folke/which-key.nvim",
event = "VeryLazy",
init = function()
vim.o.timeout = true
vim.o.timeoutlen = 300
end,
opts = {}
},
{ 'lewis6991/gitsigns.nvim', lazy = true },
{ 'windwp/nvim-ts-autotag',
config = function ()
require('nvim-ts-autotag').setup({
filetypes = { 'html', 'css', 'markdown', 'xml' }
})
end,
},
{ 'windwp/nvim-autopairs',
event = "InsertEnter", 
opts = {} 
},
{ 'folke/trouble.nvim', 
dependencies = { 
"nvim-tree/nvim-web-devicons" 
}, 
opts = {}
},
{ 'HiPhish/rainbow-delimiters.nvim' },

{ 'kaarmu/typst.vim', ft = 'typst', lazy=true,},
{ 'terrastruct/d2-vim' },
{
"f-person/auto-dark-mode.nvim",
opts = {
update_interval = 1000,
set_dark_mode = function()
vim.api.nvim_set_option_value("background", "dark", {})
vim.cmd("colorscheme argonox")
end,
set_light_mode = function()
vim.api.nvim_set_option_value("background", "light", {})
vim.cmd("colorscheme argolux")
end,
},
},

-- General Catch-All
{ 'echasnovski/mini.nvim', version = '*' },
})

-- -------------
-- NVIM SETTINGS
-- -------------

-- Enabling line numbering
vim.cmd('set number')
vim.cmd('set relativenumber')

-- Display titlebars on all panes
vim.opt.laststatus = 3

-- Set a default shift and tabwidth
vim.cmd('set shiftwidth=4')
vim.cmd('set tabstop=4')
vim.cmd('set softtabstop=4')

vim.cmd('set expandtab')

-- Fix for color issues preceeding text on dark backgrounds
if vim.o.background == 'dark' then
vim.cmd('highlight NonText ctermbg=NONE guibg=NONE')
end

-- --------
-- LUA LINE
-- --------

local function window()
return vim.api.nvim_win_get_number(0)
end

require('lualine').setup {
options = {
theme = 'argonoct-pwrln',
section_separators = { left = '▒', right = '▒' },
component_separators = { left = '', right = '' },
},
sections = {
lualine_a = { window, },
lualine_b = { 'filename', 'branch', 'diff' },
lualine_c = { 'diagnostics'},
},

winbar = {
lualine_a = { window },
lualine_b = {},
lualine_c = { 'filename' },
lualine_x = { 'diagnostics' },
lualine_y = {},
lualine_z = {}
},

inactive_winbar = {
lualine_a = { window },
lualine_b = {},
lualine_c = { 'filename' },
lualine_x = { 'diagnostics' },
lualine_y = {},
lualine_z = {}
},
}

vim.cmd('colorscheme argonox') --set theme, fix for lualine causing some weirdness


-- ---------
-- LSP SETUP
-- ---------
require('gitsigns').setup()

local lspconfig = require'lspconfig'

local on_attach = function(client)
require'completion'.on_attach(client)
local keymap_opts = { buffer = buffer }
-- Code navigation and shortcuts
vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, keymap_opts)
vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)
vim.keymap.set("n", "gD", vim.lsp.buf.implementation, keymap_opts)
vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help, keymap_opts)
vim.keymap.set("n", "1gD", vim.lsp.buf.type_definition, keymap_opts)
vim.keymap.set("n", "gr", vim.lsp.buf.references, keymap_opts)
vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, keymap_opts)
vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, keymap_opts)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)

vim.keymap.set("n", "ga", vim.lsp.buf.code_action, keymap_opts)

-- Set updatetime for CursorHold
-- 300ms of no cursor movement to trigger CursorHold
vim.opt.updatetime = 100

-- Show diagnostic popup on cursor hover
local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
callback = function()
vim.diagnostic.open_float(nil, { focusable = false })
end,
group = diag_float_grp,
})

-- Goto previous/next diagnostic warning/error
vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, keymap_opts)
vim.keymap.set("n", "g]", vim.diagnostic.goto_next, keymap_opts)
-- have a fixed column for the diagnostics to appear in
-- this removes the jitter when warnings/errors flow in
vim.wo.signcolumn = "yes"

end

lspconfig.rust_analyzer.setup({
on_attach = function(client, bufnr)
vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
end,
settings = {
["rust-analyzer"] = {
imports = {
granularity = {
group = "module",
},
prefix = "self",
},
cargo = {
buildScripts = {
enable = true,
},
},
procMacro = {
enable = true
},
checkOnSave = {
command = "clippy",
},
}
}
})

require'lspconfig'.vala_ls.setup{}

require'lspconfig'.pylsp.setup{}

--- ---------
-- TREESITTER
-- ----------

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.d2 = {
  install_info = {
    url = "https://github.com/ravsii/tree-sitter-d2",
    files = { "src/parser.c" },
    branch = "main"
  },
  filetype = "d2",
}

-- we also need to tell neovim to use "d2" filetype on "*.d2" files, as well as
-- token comment.
-- ftplugin/autocmd is also an option.
vim.filetype.add({
  extension = {
    d2 = function()
      return "d2", function(bufnr)
        vim.bo[bufnr].commentstring = "# %s"
      end
    end,
  },
})

-- -------
-- LINTING
-- -------
require('lint').linters_by_ft = {
cpp = {'cpplint'},
py = {'pylint'},
Vala = {'vala-lint'},
lua = {'luacheck'},
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
group = lint_augroup,
callback = function()
require("lint").try_lint()
end,
})

-- ---------
-- MINI NVIM
-- ---------
require('mini.indentscope').setup()
require('mini.align').setup()
require('mini.icons').setup()
require('mini.completion').setup()
require('mini.move').setup()
require('mini.splitjoin').setup()


-- ------------
-- AUTO PAIRING
-- ------------
require('nvim-autopairs').setup({
enable_check_bracket_line = true
})

require('nvim-autopairs').enable()

local Rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')
-- typst rules
npairs.add_rule(Rule("$","$","typst"))
-- markdown rules
npairs.add_rule(Rule("*", "*", "markdown"))
npairs.add_rule(Rule("_", "_", "markdown"))


-- ------------
-- HTML AUTOTAG
-- ------------
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics,
{
underline = true,
virtual_text = {
spacing = 5,
severity_limit = 'Warning',
},
update_in_insert = true,
}
)


-- --------------------------
-- Rainbow Delimiters and IBL
-- --------------------------

-- Dynamic pulling of colors, works only with themes that set these specific groups
local red    = vim.api.nvim_exec('echo synIDattr(synIDtrans(hlID("Red")), "fg#")', true)
local yellow = vim.api.nvim_exec('echo synIDattr(synIDtrans(hlID("Yellow")), "fg#")', true)
local blue   = vim.api.nvim_exec('echo synIDattr(synIDtrans(hlID("Blue")), "fg#")', true)
local orange = vim.api.nvim_exec('echo synIDattr(synIDtrans(hlID("Orange")), "fg#")', true)
local green  = vim.api.nvim_exec('echo synIDattr(synIDtrans(hlID("Green")), "fg#")', true)
local violet = vim.api.nvim_exec('echo synIDattr(synIDtrans(hlID("Purple")), "fg#")', true)
local cyan   = vim.api.nvim_exec('echo synIDattr(synIDtrans(hlID("Cyan")), "fg#")', true)

local highlight = {
"RainbowRed",
"RainbowYellow",
"RainbowBlue",
"RainbowOrange",
"RainbowGreen",
"RainbowViolet",
"RainbowCyan",
}

vim.api.nvim_set_hl(0, "RainbowRed",    { fg = red })
vim.api.nvim_set_hl(0, "RainbowYellow", { fg = yellow })
vim.api.nvim_set_hl(0, "RainbowBlue",   { fg = blue })
vim.api.nvim_set_hl(0, "RainbowOrange", { fg = orange })
vim.api.nvim_set_hl(0, "RainbowGreen",  { fg = green })
vim.api.nvim_set_hl(0, "RainbowViolet", { fg = violet })
vim.api.nvim_set_hl(0, "RainbowCyan",   { fg = cyan })
vim.g.rainbow_delimiters = { highlight = highlight }


