return {
    { -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua" },
                -- Autoinstall languages that are not installed
                auto_install = true,
                highlight = { enable = true },
            })
        end,
    },
    { -- INFO: for reference -> https://martinlwx.github.io/en/learn-to-use-text-objects-in-vim/
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,

                        keymaps = {
                            -- Methods and functions
                            ["af"] = { query = "@function.outer", desc = "Select [A]round [F]unction" },
                            ["if"] = { query = "@function.inner", desc = "Select [I]nside [F]unction" },

                            -- for loops
                            ["al"] = { query = "@loop.outer", desc = "Select [A]round [L]oop" },
                            ["il"] = { query = "@loop.inner", desc = "Select [I]nside [L]oop" },

                            -- Structs (declarations and literals) and interface declarations
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",

                            -- TODO: textobjects move and sensible selections

                            -- (assignments, constructs, ...)
                            ["ox"] = "@statement.outer",
                            ["as"] = {
                                query = "@local.scope",
                                query_group = "locals",
                                desc = "Select [A]round [S]cope",
                            },
                        },

                        include_surrounding_whitespace = true,
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = { query = "@class.outer", desc = "Next class start" },
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                        -- Below will go to either the start or the end, whichever is closer.
                        -- Use if you want more granular movements
                        -- Make it even more gradual by adding multiple queries and regex.
                        goto_next = {
                            ["]d"] = "@conditional.outer",
                        },
                        goto_previous = {
                            ["[d"] = "@conditional.outer",
                        },
                    },
                },
            })
        end,
    },
}
