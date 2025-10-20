-- =============================
-- Keymaps & Telescope Settings
-- =============================

local builtin = require("telescope.builtin")

-- Helper: find project root (Git > package.json > fallback to CWD)
local function find_project_root()
    -- Try Git first
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    if vim.v.shell_error == 0 and git_root and git_root ~= "" then
        return git_root
    end

    -- Fallback to common project markers
    local root_files = { "package.json", "pyproject.toml", "Cargo.toml", "Makefile", "prisma/schema.prisma" }
    for _, name in ipairs(root_files) do
        local path = vim.fn.findfile(name, ".;")
        if path ~= "" then
            return vim.fn.fnamemodify(path, ":p:h")
        end
    end

    -- Default to current working directory
    return vim.fn.getcwd()
end

-- =============================
-- Telescope Keymaps
-- =============================
vim.keymap.set("n", "<leader>fs", function()
    builtin.find_files({ cwd = find_project_root() })
end, { desc = "Find files (project root)", nowait = true })

vim.keymap.set("n", "<leader>fz", function()
    builtin.live_grep({ cwd = find_project_root() })
end, { desc = "Live grep (project root)", nowait = true })

vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "List open buffers", nowait = true })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Search help tags", nowait = true })
vim.keymap.set("n", "<leader>fc", builtin.git_commits, { desc = "Git commits", nowait = true })
vim.keymap.set("n", "<leader>fg", builtin.git_status, { desc = "Git status", nowait = true })

-- =============================
-- File Tree
-- =============================
vim.keymap.set("n", "<leader>e", ":NvimTreeFindFileToggle<CR>", {
    desc = "Toggle file tree",
    silent = true,
    nowait = true,
})

-- =============================
-- Formatting
-- =============================
vim.keymap.set("n", "<leader>f", function()
    require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format current buffer", nowait = true })

-- =============================
-- Copy File Paths
-- =============================
vim.keymap.set("n", "<leader>fa", function()
    local abs_path = vim.fn.expand("%:p")
    vim.fn.setreg("+", abs_path)
    print("Copied absolute path: " .. abs_path)
end, { desc = "Copy absolute file path", nowait = true })

vim.keymap.set("n", "<leader>fr", function()
    local rel_path = vim.fn.expand("%")
    vim.fn.setreg("+", rel_path)
    print("Copied relative path: " .. rel_path)
end, { desc = "Copy relative file path", nowait = true })

-- =============================
-- Buffers & Windows
-- =============================
vim.keymap.set("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New buffer", silent = true })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Close buffer", silent = true })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer", silent = true })
vim.keymap.set("n", "<leader>bl", "<cmd>bnext<CR>", { desc = "Next buffer", silent = true })

vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertical" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontal" })
vim.keymap.set("n", "<leader>sc", "<C-w>c", { desc = "Close split" })
vim.keymap.set("n", "<leader>so", "<C-w>o", { desc = "Only current split" })

-- =============================
-- Core Editor
-- =============================
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit window" })
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit all (force)" })
vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- =============================
-- Diagnostics (LSP)
-- =============================
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- =============================
-- LSP / Code Navigation
-- =============================
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "List references" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

-- =============================
-- Misc Utilities
-- =============================
vim.keymap.set("n", "<leader>xr", "<cmd>source $MYVIMRC<CR>", { desc = "Reload config" })
vim.keymap.set("n", "<leader>tw", function()
    vim.wo.wrap = not vim.wo.wrap
    print("Wrap " .. (vim.wo.wrap and "enabled" or "disabled"))
end, { desc = "Toggle wrap" })

-- Make leader keys snappy
vim.opt.timeout = true
vim.opt.timeoutlen = 300
