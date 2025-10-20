require("keymaps")
require("options")
require("plugins.lazy")
require("plugins.keymaps")
require("plugins.options")
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Lua
-- Lua
-- Lua
-- Default options:

vim.g.parinfer_mode = "smart"

--require('onedark').load()
--vim.cmd.colorscheme("onedark")
-- Manual formatting shortcut
-- Rainbow delimiters configuration
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
-- Load Catppuccin theme

-- Install with your plugin manager first:
-- use { "catppuccin/nvim", as = "catppuccin" }

-- Using Lazy
-- Lua
-- Lua
--color_scheme.rand_colorscheme()
---- Default options:
-- Make sure you have the plugin installed:
-- Lazy.nvim:  { "rebelot/kanagawa.nvim" }
-- Packer:     use { "rebelot/kanagawa.nvim" }

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (workspace)" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Diagnostics (buffer)" })
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location list" })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix list" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})
