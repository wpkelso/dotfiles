local settings = {
    format = {
        shift_width = 4,

    },
    lint = {
        enabled = false,
        command = "mmdc",
    },
    preview = {
        renderer = "mermaid.js",
        theme = "default",
    },
}

local M = {
    "kevalin/mermaid.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = settings,
}

return M
