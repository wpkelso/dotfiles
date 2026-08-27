local C = {}

C["name"] = "perl-lsp"
C["config"] = {
    cmd = { "perl-lsp" },
    filetypes = { "perl" },
    root_markers = { "cpanfile", "Makefile.PL", "Build.PL", ".git" },

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
