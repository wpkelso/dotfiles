local settings = {
    snippets = {
        require 'mini.snippets'.gen_loader.from_file('~/.config/nvim/snippets/global.json'),
        require 'mini.snippets'.gen_loader.from_lang(),
    },
    expand = {
        insert = function(snippet, _) vim.snippet.expand(snippet.body) end
    },
}

local M = {
    "nvim-mini/mini.snippets",
    version = "*",
    opts = settings,
}

return M
