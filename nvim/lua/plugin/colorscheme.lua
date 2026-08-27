local M = {
    --"wpkelso/argonoct-neovim",
    dir = "/home/nppdev/repos/argonoct-neovim",
    name = "argonoct",
    lazy = false,
    priority = 1000,
}

function M.config()
    vim.cmd.colorscheme "argolux"
end

return M
