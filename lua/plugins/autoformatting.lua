-- NOTE: https://kitsugo.com/guide/nvim-default-formatter/
-- NOTE: could be useful in the future
return {
    "stevearc/conform.nvim",
    opts = {
        notify_on_error = true,
        format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
        },
        formatters_by_ft = {
            lua = { "stylua" },
        },
    },
}
