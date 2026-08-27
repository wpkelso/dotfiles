local M = {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
}

function M.init()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
end

return M
