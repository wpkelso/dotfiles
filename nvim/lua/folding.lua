vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 00
vim.opt.foldtext = ''
vim.opt.foldenable = true

vim.api.nvim_create_autocmd({'BufReadPost','FileReadPost'}, {
    pattern = "*",
    command = "normal zR",

})
