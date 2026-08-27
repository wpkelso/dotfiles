vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled())
vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())

local cpath = vim.fs.normalize("$HOME/.config/nvim/lua/server/")

function lang(item)
    c = dofile(vim.fs.joinpath(cpath, item) .. ".lua")
    vim.lsp.config(c["name"], c["config"])
    vim.lsp.enable(c["name"])
end
