local C = {}

C["name"] = "zubanls"
C["config"] = {
    name = "ZubanLS",
    cmd = { "zuban", "server" },
    root_markers = { "pyproject.toml", ".git" },
    filetypes = { "python" },
    on_attach = function(client, bufnr)
        vim.lsp.completion.enable(true, client.id, bufnr, {
            autotrigger = true,
            convert = function(item)
                return { abbr = item.label:gsub('%b()', '')}
            end,
        })
    end,
}

return C
