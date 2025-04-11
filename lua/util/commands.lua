M = {}

function M.ToggleDiagnosticSigns()
    local enabled = vim.diagnostic.config()["signs"]
    vim.diagnostic.config({ signs = not enabled })
end

function M.ToggleDiagnostics()
    if vim.diagnostic.is_enabled() then
        vim.diagnostic.enable(false)
    else
        vim.diagnostic.enable(true)
    end
end

vim.cmd("command ToggleDiagnosticSigns lua M.ToggleDiagnosticSigns()")

vim.cmd("command ToggleDiagnostics lua M.ToggleDiagnostics()")
