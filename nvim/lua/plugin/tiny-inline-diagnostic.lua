local M = {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
}

function M.config()
    require "tiny-inline-diagnostic".setup()
    -- Disable Neovim's default virtual text diagnostics
    vim.diagnostic.config({ virtual_text = false })
end

return M
