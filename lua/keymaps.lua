-- spacebar bar leader key
vim.g.mapleader = " "

-- buffers
vim.keymap.set("n", "<leader>n", ":bn<cr>")
vim.keymap.set("n", "<leader>p", ":bp<cr>")
--vim.keymap.set("n", "<leader>x", ":bd<cr>")
vim.keymap.set("n", "<leader>x", "<cmd>bdelete<CR>", {
    desc = "Close current buffer",
    silent = true,
    nowait = true, -- instantly executes, no delay
})

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
