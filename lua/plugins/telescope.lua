return {
    "nvim-telescope/telescope.nvim",
    -- BUG: weird compatibility issue, waiting for new release > 0.1.8, switch to rolling release in th emeantime
    -- branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
        local actions = require("telescope.actions.layout")
        require("telescope").setup({
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
            },
            defaults = {
                mappings = {
                    i = {
                        ["<c-l>"] = actions.toggle_preview, -- This universal keybind remains useful
                    },
                    n = {
                        ["<c-l>"] = actions.toggle_preview,
                    },
                },
                preview = {
                    hide_on_startup = false, -- Default for other pickers (preview visible)
                },
            },

            pickers = {
                diagnostics = {
                    preview = {
                        hide_on_startup = true, -- <--- This hides the preview specifically for diagnostics
                    },
                },
            },
        })

        pcall(require("telescope").load_extension, "fzf")

        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
        vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
        vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
        vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })

        vim.keymap.set("n", "<leader>/", function()
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                winblend = 10,
                previewer = false,
            }))
        end, { desc = "[/] Fuzzily search in current buffer" })
    end,
}
