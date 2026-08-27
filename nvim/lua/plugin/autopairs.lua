local settings = {
    enable_check_bracket_line = true
}

local M = {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = settings,
}

return M
