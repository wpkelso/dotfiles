local C = {}

C["name"] = "lua-ls"
C["config"] = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = {
        ".luarc.json",
        ".luarc.jsonc",
        ".luacheckrc",
        ".stylua.toml",
        ".git",
    },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            }
        }
    },
    on_attach = function(client, bufnr)
        vim.lsp.completion.enable(true, client.id, bufnr, {
            autotrigger = true,
            convert = function(item)
                return { abbr = item.label:gsub("%b()", "")}
            end,
        })
    end,
}

return C
