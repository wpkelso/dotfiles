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
      { 'talha-akram/noctis.nvim',
      name = 'notcis',
      --lazy = false,
      --priority = 1000,
      --config = function()
      --  vim.cmd([[colorscheme noctis_obscuro]])
      --end,
  },
  { 'effkay/argonaut.vim',
    name = 'argonaut',
    --lazy = false,
    --priority = 1000,
    --config = function()
    --  vim.cmd([[colorscheme argonaut]])
    --end,
  },
  { 'kepano/flexoki-neovim',
    name = 'flexoki',
    --lazy = false,
    --priority = 1000,
    --config = function()
    --  vim.cmd([[colorscheme flexoki-light]])
    --end,
  },
  { --'wpkelso/argonoct-neovim',
      dir = '~/Documents/argonoct-neovim/',
      name = 'argonoct',
      lazy=false,
      priority = 1000,
      config = function()
          vim.cmd([[colorscheme argonoct-dark]])
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
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", lazy = false },
  { "stevearc/dressing.nvim", event = "VeryLazy" },
  { "MunifTanjim/nui.nvim" },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl" },
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
  { 'pocco81/auto-save.nvim' },
  { 'HiPhish/rainbow-delimiters.nvim' },
  { 'FluxxField/bionic-reading.nvim', opts = {} },
  {"folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = {}},
})

-- --------
-- LUA LINE
-- --------

local function window()
  return vim.api.nvim_win_get_number(0)
end

require('lualine').setup {
  options = {
    theme = 'argonoct-dark-pwrln',
    section_separators = { left = '', right = '' },
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

vim.cmd('colorscheme argonoct-dark') --fix for lualine causing some weirdness

-- ---------
-- LSP SETUP
-- ---------

require('gitsigns').setup()
require("mason").setup()
require("mason-lspconfig").setup{
  ensure_installed = { "clangd", "lua_ls", "pylsp", "rust_analyzer", "taplo", "typst_lsp", "cssls", "html" },
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

-- -------------------
-- NVIM CMP (LUA SNIP)
-- -------------------

local luasnip = require("luasnip")
local cmp = require("cmp")

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
require('lspconfig')["rust_analyzer"].setup {
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
--require('lspconfig')["html"].setup {
  --    capabilities = capabilities
  --}

  -- --------------------------
  -- Rainbow Delimiters and IBL
  -- --------------------------

  -- Dynamic pulling of colors
  local red    = vim.api.nvim_exec('echo synIDattr(synIDtrans(hlID("Red")), "fg#")', true)
  local yellow = vim.api.nvim_exec('echo synIDattr(synIDtrans(hlID("Yellow")), "fg#")', true)
  local blue   = vim.api.nvim_exec('echo synIDattr(synIDtrans(hlID("Blue")), "fg#")', true)
  local orange = vim.api.nvim_exec('echo synIDattr(synIDtrans(hlID("Orange")), "fg#")', true)
  local green  = vim.api.nvim_exec('echo synIDattr(synIDtrans(hlID("Green")), "fg#")', true)
  local violet = vim.api.nvim_exec('echo synIDattr(synIDtrans(hlID("Purple")), "fg#")', true)
  local cyan   = vim.api.nvim_exec('echo synIDattr(synIDtrans(hlID("Cyan")), "fg#")', true)

  -- Static colors (Argonaut)
  --local red = '#ff000f'
  --local yellow = '#ffb900'
  --local blue = '#008df8'
  --local orange = '#f2860d'
  --local green = '#8ce10b'
  --local violet = '#6d43a6'
  --local cyan = '#00d8eb'

  local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
  }
  local hooks = require "ibl.hooks"
  -- create the highlight groups in the highlight setup hook, so they are reset
  -- every time the colorscheme changes
  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed",    { fg = red })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = yellow })
    vim.api.nvim_set_hl(0, "RainbowBlue",   { fg = blue })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = orange })
    vim.api.nvim_set_hl(0, "RainbowGreen",  { fg = green })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = violet })
    vim.api.nvim_set_hl(0, "RainbowCyan",   { fg = cyan })
  end)

  vim.g.rainbow_delimiters = { highlight = highlight }
  require("ibl").setup { scope = { highlight = highlight } }

  hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)


  -- ---------
  -- AUTO SAVE
  -- ---------
  require('auto-save').setup {
    enabled = false
  }

  -- ---------
  -- MINI.NVIM
  -- ---------
  require('mini.surround').setup()
  require('mini.comment').setup()
  require('mini.align').setup()
  -- require('mini.move').setup() --Disabled because it was getting annoying it, but unsure as to whether or not I actually want to remove it

  -- ------------
  -- AUTO PAIRING
  -- ------------

  local Rule = require('nvim-autopairs.rule')
  local npairs = require('nvim-autopairs')
  -- typst rules
  npairs.add_rule(Rule("$","$","typst"))
  -- markdown rules
  npairs.add_rule(Rule("*", "*", "markdown"))
  npairs.add_rule(Rule("_", "_", "markdown"))
  -- html rules
  npairs.add_rules({
    Rule("<html%s>$", "</html>", "html")
    :use_regex(true)
  })
  npairs.add_rules({
    Rule("<head%s>$", "</head>", "html")
  })
  npairs.add_rules({
    Rule("<body%s>$", "</body>", "html")
    :use_regex(true)
  })
  npairs.add_rules({
    Rule("<div%s>$", "</div>", "html")
    :use_regex(true)
  })
  npairs.add_rules({
    Rule("<a%s>$", "</a>", "html")
    :use_regex(true)
  })

  -- Making sure EditorConfig support is enabled
  vim.g.editorconfig = true

  -- Enabling line numbering
  vim.cmd('set number')
  vim.cmd('set relativenumber')
  vim.cmd('set laststatus=3')
  vim.cmd('set tabstop=4')
  vim.cmd('set shiftwidth=4')
  vim.cmd('set expandtab')
  vim.cmd('ASToggle')

  -- Fix for color issues preceeding text on dark backgrounds
  if vim.o.background == 'dark' then
    vim.cmd('highlight NonText ctermbg=NONE guibg=NONE')
  end
