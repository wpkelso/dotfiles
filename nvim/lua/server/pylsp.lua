local C = {}

C["name"] = "pylsp"
C["config"] = {
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    enable=true,
                    hangClosing=false,
                    maxLineLength=100,
                    indentSize=4,
                },
                rope_autoimport = {
                    completions = {
                        enabled=true
                    },
                    code_actions = {
                        enabled=true
                    },
                },
                rope_completion = {
                    enabled=true,
                    eager=false,
                }
            }
        }
    },
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
