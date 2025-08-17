local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fs", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fz", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fp", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fo", builtin.help_tags, { desc = "Telescope help tags" })

-- tree
vim.keymap.set("n", "<leader>e", ":NvimTreeFindFileToggle<cr>")
