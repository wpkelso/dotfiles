local settings = {
    draw = {
        delay = 100,
        animation = require "mini.indentscope".gen_animation.none(),
        predicate = function(scope) return not scope.body.is_incomplete end,
        priority = 2,
    }
}

local M = {
    "nvim-mini/mini.indentscope",
    version = "*",
    opts = settings,
}

return M
