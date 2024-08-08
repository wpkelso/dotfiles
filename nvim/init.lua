-- ----------- --
-- NVIM CONFIG --
-- ----------- --
vim.opt.termguicolors = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { --'wpkelso/argonoct-neovim',
    dir = '~/Documents/argonoct-neovim/',
    name = 'argonoct',
    lazy=false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme argolux]])
    end,
  },
  { 'echasnovski/mini.nvim', version = false },
  { 'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp'
  },
  { 'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    lazy = false,
    dependencies = {
      "kmarius/jsregexp",
      build = "make install_jsregexp",
    },
  },
  { "nvim-lualine/lualine.nvim", lazy = false },
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      require('nvim-treesitter.configs').setup({
        auto_install = true,
        ensure_installed = {
          "lua",
          "toml",
          "css",
          "html",
          "lua",
          "rust",
          "c",
        },
        highlight = {
          enable = true,
          use_languagetree = true,
        },
        indent = { enable = true },
      })
    end,
    lazy = false,
  },
  { 'windwp/nvim-ts-autotag',
    config = function ()
      require('nvim-ts-autotag').setup({
        filetypes = { 'html', 'css', 'markdown', 'xml' }
      })
    end,
  },
  { "stevearc/dressing.nvim", event = "VeryLazy" },
  { "MunifTanjim/nui.nvim" },
  -- { "lukas-reineke/indent-blankline.nvim", main = "ibl", version = "3.6", opts = {} },
  { "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {}
  },
  { "mfussenegger/nvim-lint" },
  { 'lewis6991/gitsigns.nvim', lazy = true },
  { "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    lazy = true
  },
  { 'kaarmu/typst.vim', ft = 'typst', lazy=true,},
  { 'windwp/nvim-autopairs', event = "InsertEnter", opts = {} },
  { 'HiPhish/rainbow-delimiters.nvim' },
  { 'FluxxField/bionic-reading.nvim', opts = {} },
  { 'folke/trouble.nvim', dependencies = { "nvim-tree/nvim-web-devicons" }, opts = {}},
  { 'mrcjkb/rustaceanvim', version = '^5', lazy = false,},
})

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

vim.cmd('colorscheme argolux') --fix for lualine causing some weirdness

-- ---------
-- LSP SETUP
-- ---------

require('gitsigns').setup()
require("mason").setup()
require("mason-lspconfig").setup{
  ensure_installed = { "clangd", "lua_ls", "pylsp", "taplo", "typst_lsp", "cssls", "html" },
}

require'lspconfig'.typst_lsp.setup{
  settings = {
    exportPdf = "onSave" -- Choose onType, onSave or never.
    -- serverPath = "" -- Normally, there is no need to uncomment it.
  }
}

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

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

-- -------------------
-- NVIM CMP (LUA SNIP)
-- -------------------

local luasnip = require("luasnip")
local cmp = require("cmp")
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
      { name = 'buffer' },
    })
})

cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')["clangd"].setup {
  capabilities = capabilities
}
require('lspconfig')["lua_ls"].setup {
  capabilities = capabilities
}
require('lspconfig')["pylsp"].setup {
  capabilities = capabilities
}
require('lspconfig')["taplo"].setup {
  capabilities = capabilities
}
require('lspconfig')["typst_lsp"].setup {
  capabilities = capabilities
}
require('lspconfig')["cssls"].setup {
  capabilities = capabilities
}
require('lspconfig')["biome"].setup {
  capabilities = capabilities
}
require('lspconfig')["html"].setup {
  capabilities = capabilities
}

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

--temporarily setting up highlight groups separate from ibl because it broke
vim.api.nvim_set_hl(0, "RainbowRed",    { fg = red })
vim.api.nvim_set_hl(0, "RainbowYellow", { fg = yellow })
vim.api.nvim_set_hl(0, "RainbowBlue",   { fg = blue })
vim.api.nvim_set_hl(0, "RainbowOrange", { fg = orange })
vim.api.nvim_set_hl(0, "RainbowGreen",  { fg = green })
vim.api.nvim_set_hl(0, "RainbowViolet", { fg = violet })
vim.api.nvim_set_hl(0, "RainbowCyan",   { fg = cyan })

--  local hooks = require "ibl.hooks"
--  -- create the highlight groups in the highlight setup hook, so they are reset
--  -- every time the colorscheme changes
--  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
--    vim.api.nvim_set_hl(0, "RainbowRed",    { fg = red })
--    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = yellow })
--    vim.api.nvim_set_hl(0, "RainbowBlue",   { fg = blue })
--    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = orange })
--    vim.api.nvim_set_hl(0, "RainbowGreen",  { fg = green })
--    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = violet })
--    vim.api.nvim_set_hl(0, "RainbowCyan",   { fg = cyan })
--  end)
--
vim.g.rainbow_delimiters = { highlight = highlight }
--  require("ibl").setup { scope = { highlight = highlight } } --rainbow_delimiters.nvim integration
--  require("ibl").setup()
--
--  hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)



-- ---------
-- MINI.NVIM
-- ---------
require('mini.surround').setup()
require('mini.comment').setup()
require('mini.align').setup()



-- ---------
-- Rustacean
-- ---------
vim.g.rustaceanvim = {
  tools = {

  }
}


-- Enabling line numbering
vim.cmd('set number')
vim.cmd('set relativenumber')
vim.opt.laststatus = 3
vim.cmd('set shiftwidth=4')
vim.cmd('set expandtab')

-- Fix for color issues preceeding text on dark backgrounds
if vim.o.background == 'dark' then
  vim.cmd('highlight NonText ctermbg=NONE guibg=NONE')
end

-- Making sure EditorConfig support is enabled
vim.g.editorconfig = true

