-- NOTES

-- Quick reminder for Lazy
--  'build' runs on install
--  'config' runs on startup and likely requires explicit **.setup({...}) since it does not run automatically
--  'opts' sets the options that get passed to **.setup({...}) implicitely. Empty field implies defauls and missing field means no startup

-- CONFIG FILE --

-- Pay respect to your mom!
print("Hi Mom!")

-- Set leader key to <SPACE>
-- NOTE: must happed before plugin loading to be effective
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable Nerd Font (A nerd fonr needs to be set in the terminal emulator)
vim.g.have_nerd_font = true

-- Set relevant options

vim.opt.number = true -- Show row numbers
vim.opt.relativenumber = true -- Set relative row numbers

vim.schedule(function()
    vim.opt.clipboard = "unnamedplus" -- Sync clipboard between nvim and OS (schedule for startup optimization)
end)

vim.opt.undofile = true -- File history saved to undo file in `undodir`directory

vim.opt.scrolloff = 10 -- Minimum lines between cursor and top/bottom edges

-- Setting up the plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        error("Error cloning lazy.nvim:\n" .. out)
    end
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Install plugins
require("lazy").setup({
    -- Detect tabstop and shiftwidth automatically
    "tpope/vim-sleuth",

    -- Set colorscheme to tokyonight (night style)
    {
        "folke/tokyonight.nvim",
        lazy = false, -- main colorscheme has to load at startup
        priority = 1000, -- and needs to load first
        config = function() -- set the colorscheme during the configuration of the plugin
            vim.cmd.colorscheme("tokyonight-night")
        end,
    },

    require("plugins.treesitter"),
    require("plugins.lsp"),
    require("plugins.autoformatting"),
})
