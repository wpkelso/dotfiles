local function window()
    return vim.api.nvim_win_get_number(0)
end

local settings = {
  options = {
    theme = 'argonoct-pwrln',
    section_separators = { left = '▌', right = '▐' },
    component_separators = { left = '', right = '' },
    always_show_tabline = true,
    globalstatus = true,
  },

  sections = {
    lualine_a = {
      'mode',
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {
      {
        'encoding',
        show_bomb = true,
      },
      {
        'fileformat',
        symbols = {
          unix = 'UNIX',
          dos = 'DOS',
          mac = 'MACOS',
        },
      },
      {
        'filetype',
        colored = false,
        icon_only = false,
      },
    },
    lualine_z = {
      'progress',
      'location',
    }
  },

  winbar = {
    lualine_a = {
      window
    },
    lualine_b = {
      {
        'filetype',
        draw_empty=true,
        colored = false,
        icon_only = true,
      },
      {
        'filename',
        file_states = true,
        path = 3,
      },
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {
      { 'branch', colored=false },
      { 'diff', colored = false, draw_empty = true },
    },
    lualine_z = {
      'lsp_status',
      {
        'diagnostics',
        sources = {'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'vim_lsp'},
        symbols = {error = ' ', warn = ' ', info = ' ', hint = '󰟃 '},
        colored = false,
        update_in_insert = false,
        always_visible = true,
      },
    },
  },

  inactive_winbar = {
    lualine_a = {
      window
    },
    lualine_b = {
      {
        'filetype',
        draw_empty=true,
        colored = false,
        icon_only = true,
      },
      {
        'filename',
        fiel_states = true,
        path = 3,
      },
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {
      {
        'branch',
        colored=false
      },
      {
        'diff',
        colored = false,
        draw_empty = true
      },
    },
    lualine_z = {
      'lsp_status',
      {
        'diagnostics',
        sources = {'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'vim_lsp'},
        symbols = {error = ' ', warn = ' ', info = ' ', hint = '󰟃 '},
        colored = false,
        update_in_insert = false,
        always_visible = true,
      },
    },
  },

  tabline = {
    lualine_a = {},
    lualine_b = { {
      'tabs',
      mode = 0,
      path = 3,
      show_modified_status = false,
      max_length = vim.o.columns * 1 / 2,
      use_mode_colors = true,
    }, },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { {
      'buffers',
      show_filename_only = false,
      hide_filename_extension = false,
      show_modified_status = true,
      max_length = vim.o.columns * 1 / 2,
      mode = 0,
      use_mode_colors = true,
    }, },
    lualine_z = {},
  },
}

local M = {
    "nvim-lualine/lualine.nvim",
    opts = settings,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
}

return M
