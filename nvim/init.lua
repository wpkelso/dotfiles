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
	{ 'effkay/argonaut.vim',
		name = 'argonaut',
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme argonaut]])
		end,
	},
	{ 'kepano/flexoki-neovim',
		name = 'flexoki',
	},
	{ 'echasnovski/mini.nvim', version = false },
	{ 'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		'hrsh7th/cmp-cmdline',
		'hrsh7th/nvim-cmp'
	},
	{ 'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip'
	},
	{ "nvim-lualine/lualine.nvim", lazy = false },
	{ "nvim-tree/nvim-web-devicons" },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "stevearc/dressing.nvim", event = "VeryLazy" },
	{ "MunifTanjim/nui.nvim" },
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl" },
	{ "folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			}
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

})

vim.opt.termguicolors = true

-- --------
-- LUA LINE
-- --------

local function window()
  return vim.api.nvim_win_get_number(0)
end

require('lualine').setup {
  options = {
	theme = 'powerline_dark',
  	section_separators = '',
	component_separators = '',
  },
  sections = {
    lualine_a = { window, },
    lualine_b = { 'filename', 'branch', 'diff' },
    lualine_c = { 'diagnostics'},
  },

  winbar = {
  lualine_a = { window },
  lualine_b = {},
  lualine_c = {'filename'},
  lualine_x = {},
  lualine_y = {},
  lualine_z = {}
  },

  inactive_winbar = {
    lualine_a = { window },
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
}

-- ---------
-- LSP SETUP
-- ---------

require('gitsigns').setup()
require("mason").setup()
require("mason-lspconfig").setup{
	ensure_installed = { "clangd", "lua_ls", "pylsp", "rust_analyzer", "taplo", "typst_lsp" },
}

require'lspconfig'.typst_lsp.setup{
	settings = {
      exportPdf = "onType" -- Choose onType, onSave or never.
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


-- --------------------------
-- Rainbow Delimiters and IBL
-- --------------------------

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
  vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#FF000F" })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#FFB900" })
  vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#008DF8" })
  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#FF8308" })
  vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#8CE10B" })
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#6D43A6" })
  vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#00D8EB" })
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

-- ------------
-- AUTO PAIRING
-- ------------

local Rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')
npairs.add_rule(Rule("$","$","typst"))

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

-- Fix color issues preceeding text
vim.cmd('highlight NonText ctermbg=NONE guibg=NONE')
