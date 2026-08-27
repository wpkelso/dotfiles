local C = {}

C["name"] = "clangd"
C["config"] = {
    cmd = { "clangd", "--background-index", "--clang-tidy", },
    capabilities = {
        offsetEncoding = { "utf-8", "utf-16" },
        textDocument = {
            completion = {
                editsNearCursor = true
            },
            semanticTokens = {
                multilineTokenSupport = true,
            },
        }
    },
    filetypes = {
        "c",
        "cpp",
    },
    root_markers = {
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "compile_commands.json",
        "compile_flags.txt",
        "configure.ac",
        ".git",
    },
    on_attach = function(client, bufnr)
        vim.lsp.completion.enable(true, client.id, bufnr, {
            autotrigger = true,
            convert = function(item)
                return { abbr = item.label:gsub("%b()", "")}
            end,
        })

        vim.api.nvim_buf_create_user_command(bufnr, "LspClangdSwitchSourceHeader", function()
          switch_source_header(bufnr, client)
        end, { desc = "Switch between source/header" })

        vim.api.nvim_buf_create_user_command(bufnr, "LspClangdShowSymbolInfo", function()
          symbol_info(bufnr, client)
        end, { desc = "Show symbol info" })
    end,
}

return C
