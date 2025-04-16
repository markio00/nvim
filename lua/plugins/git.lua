return {
    {
        "luukvbaal/statuscol.nvim",
        config = function()
            -- Example configuration in init.lua
            require("statuscol").setup({
                segments = {
                    {
                        sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, wrap = true },
                        click = "v:lua.ScSa",
                    },
                    { sign = { namespace = { "diagnostic" }, fillchar = " ", maxwidth = 1 }, click = "v:lua.ScSa" }, -- Diagnostic signs
                    { text = { "%l" }, click = "v:lua.ScLa", condition = { true } }, -- Line number
                    {
                        sign = { namespace = { "gitsigns" }, fillchar = " ", maxwidth = 1 },
                        align = "right",
                        padding = { left = 1 },
                    }, -- Git signs
                },
            })
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            -- FIX: `numhl` conflicts (9verrides) 'cursorline' fg highlights
            numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
            -- FIX: `linehl` confilcts (overrides) 'todo_comments' bg highlights -> see 'gitsigns' sign changed event and todo_comments 'draw_highlights'
            linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        },
    },
    {
        "tpope/vim-fugitive",
    },
}
