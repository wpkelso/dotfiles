require "opts"
require "launch"
require "diagnostics"

spec("plugin.autopairs")
spec("plugin.colorscheme")
spec("plugin.d2lang")
spec("plugin.dap")
spec("plugin.dap-view")
spec("plugin.darklight")
spec("plugin.gitsigns")
spec("plugin.lspconfig")
spec("plugin.lualine")
spec("plugin.mermaid")
spec("plugin.mini")
spec("plugin.mini-indentscope")
spec("plugin.mini-snippets")
spec("plugin.mini-splitjoin")
spec("plugin.mini-surround")
spec("plugin.tiny-inline-diagnostic")
spec("plugin.treesitter")
spec("plugin.treewalker")
spec("plugin.trouble")
spec("plugin.which-key")
require "lazy-nvim"

require "lsp"
lang("clangd")
lang("lua-ls")
lang("perl-lsp")
lang("zubanls")

if vim.g.neovide then
    require "neovide"
end

require "treesitter"
require "folding"
require "keymaps"
