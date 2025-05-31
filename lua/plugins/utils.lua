return {
    {
        "folke/todo-comments.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("todo-comments").setup({
                sign_priority = 8, -- sign priority
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            })
            vim.keymap.set("n", "<leader>lt", "<cmd>TodoTelescope<CR>", { desc = "[L]ist [T]odos" })
        end,
        main = "todo-comments",
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            spec = {
                { "<leader>g", group = "[G]o to" },
                { "s", group = "[S]earch" },
                { "<leader>t", group = "[T]oggle" },
                { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
            },
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
}
