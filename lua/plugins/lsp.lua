-- Sets up lsp related plugins
M = {
    "neovim/nvim-lspconfig", -- Provides default settings and programatic configurations for the language servers. Also responsable for ':Lsp...` commands'
    dependencies = {
        "williamboman/mason.nvim", -- Package manager for LSP. DAPs, linters & formatters,
        "williamboman/mason-lspconfig.nvim", -- Bridge between mason and lspconfig. Avoids single server setups, automates plugins configuration, translates between lspconfig and mason names.
        "WhoIsSethDaniel/mason-tool-installer.nvim", -- Enables finer contorl on the installed version of plugins, introduces CMDs and APIs to further control mason programaticaly.
        "folke/trouble.nvim",
        require("plugins.completion"),
    },

    config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("mynvim-lsp-attach", { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end
                local tele = require("telescope.builtin")

                vim.lsp.inlay_hint.enable()

                vim.diagnostic.config({
                    float = true,
                    jump = {
                        float = false,
                        wrap = true,
                    },
                    severity_sort = false,
                    signs = true,
                    underline = true,
                    update_in_insert = false,
                    virtual_lines = false,
                    virtual_text = true,
                })

                map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                map("<leader>gd", tele.lsp_definitions, "[G]oto [D]efinition")
                map("<leader>gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                map("<leader>gi", tele.lsp_implementations, "[G]oto [I]mplementation")
                map("<leader>gr", tele.lsp_references, "[G]oto [R]eference")
                map("<leader>lws", tele.lsp_dynamic_workspace_symbols, "[L]ist [W]orkspace [S]ymbols")
                map("<leader>lds", tele.lsp_document_symbols, "[S]earch [D]ocument [S]ymbols")
                map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
                map("<leader>gt", tele.lsp_type_definitions, "[G]oto [T]ype [D]efinition")
            end,
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

        local servers = {
            gopls = {
                settings = {
                    gopls = {
                        -- more settings: https://github.com/golang/tools/blob/master/gopls/doc/settings.md

                        -- Build
                        buildFlags = { "-tags", "integration" },

                        -- Formatting
                        gofumpt = true,
                        -- local = "<module name in go.mod>"

                        -- UI
                        codelenses = {
                            generate = true, -- show the `go generate` lens.
                            gc_details = true, -- Show a code lens toggling the display of gc's choices.
                            test = true,
                            tidy = true,
                            vendor = true,
                            regenerate_cgo = true,
                            upgrade_dependency = true,
                        },
                        semanticTokens = true, -- WARN: significant highlight change, go.nvim config says conflicts gopls/nvim
                        semanticTokenTypes = { string = false }, -- disable semantic string tokens so we can use treesitter highlight injection

                        -- Completion
                        usePlaceholders = true,
                        matcher = "Fuzzy",

                        -- Diagnostic
                        analyses = {
                            unreachable = true,
                            nilness = true,
                            unusedparams = true,
                            useany = true,
                            unusedwrite = true,
                            ST1003 = true,
                            undeclaredname = true,
                            fillreturns = true,
                            nonewvars = true,
                            fieldalignment = false,
                            shadow = true,
                        },
                        staticcheck = true,
                        vulncheck = "Imports",
                        diagnosticsDelay = "500ms",

                        -- Documentation

                        -- Inlay Hint
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },

                        -- Navigation
                        symbolMatcher = "fuzzy",
                    },
                },
            },

            -- NOTE: it is important to add handler to formatting handlers
            -- the async formatter will call these handlers when gopls responed
            -- without these handlers, the file will not be saved
            lua_ls = {
                -- cmd = {...},
                -- filetypes { ...},
                -- capabilities = {},
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        workspace = {
                            checkThirdParty = false,
                            -- Tells lua_ls where to find all the Lua files that you have loaded
                            -- for your neovim configuration.
                            library = {
                                "${3rd}/luv/library",
                                unpack(vim.api.nvim_get_runtime_file("", true)),
                            },
                        },
                    },
                },
            },
        }

        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            "stylua",
        })

        require("mason").setup()
        require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
        ---@diagnostic disable-next-line: missing-fields
        require("mason-lspconfig").setup({
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend("force", capabilities, server.capabilities or {})
                    require("lspconfig")[server_name].setup(server)
                end,
            },
        })
    end,
}

return M
