-- Sets up lsp related plugins

return {
    "neovim/nvim-lspconfig", -- Provides default settings and programatic configurations for the language servers. Also responsable for ':Lsp...` commands'

    dependencies = {
        "williamboman/mason.nvim", -- Package manager for LSP. DAPs, linters & formatters,
        "williamboman/mason-lspconfig.nvim", -- Bridge between mason and lspconfig. Avoids single server setups, automates plugins configuration, translates between lspconfig and mason names.
        "WhoIsSethDaniel/mason-tool-installer.nvim", -- Enables finer contorl on the installed version of plugins, introduces CMDs and APIs to further control mason programaticaly.
        require("plugins.completion"),
        "ray-x/go.nvim",
    },

    config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("mynvim-lsp-attach", { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end
                local tele = require("telescope.builtin")

                map("gd", tele.lsp_definitions, "[G]oto [D]efinition")
                map("gr", tele.lsp_references, "[G]oto [R]eference")
                map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
            end,
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

        local servers = {
            gopls = {},
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
        require("go").setup({
            lsp_cfg = false,
        })
        local cfg = require("go.lsp").config() -- config() return the go.nvim gopls setup

        require("lspconfig").gopls.setup(cfg)
    end,
}
