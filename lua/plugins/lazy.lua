-- Install lazylazy
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

require("lazy").setup({


    -- Color scheme
    { "catppuccin/nvim",               as = "catppuccin" },

    -- Using Lazy
    {
        "navarasu/onedark.nvim",
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('onedark').setup {
                style = 'darker'
            }
            -- Enable theme
            require('onedark').load()
        end
    },

    -- Fuzzy Finder (files, lsp, etc)
    { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },

    -- File tree
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        requires = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup({})
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
    },

    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },
    -- Save and load buffers (a session) automatically for each folder
    {
        "rmagatti/auto-session",
        config = function()
            require("auto-session").setup({
                log_level = "error",
                auto_session_suppress_dirs = { "~/", "~/Downloads" },
            })
        end,
    },

    -- Comment code
    {
        "terrortylor/nvim-comment",
        config = function()
            require("nvim_comment").setup({ create_mappings = false })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "lua",
                "vim",
                "vimdoc",
                "typescript",
                "tsx",
                "javascript",
                "java",
                "json",
                "html",
                "css",
                "python"
            },
            highlight = { enable = true },
            indent = { enable = false },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    -- Visualize buffers as tabs
    { "akinsho/bufferline.nvim",        version = "*",     dependencies = "nvim-tree/nvim-web-devicons" },

    -- LSP Zero (main LSP configuration)
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        lazy = true,
        config = false,
        init = function()
            -- Disable automatic setup, we are doing it manually
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = true,
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",         -- Snippets engine
            "saadparwaiz1/cmp_luasnip", -- LuaSnip source
            "windwp/nvim-autopairs",    -- Autopairs
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")

            -- Load friendly-snippets if you want a big snippet collection
            require("luasnip.loaders.from_vscode").lazy_load()

            -- autopairs integration
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

            -- Tab complete helper
            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),

                    -- Tab / Shift-Tab smart behavior
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                    { name = "path" },
                }),
                formatting = {
                    format = function(entry, vim_item)
                        -- Show source name (optional, nice UX)
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip  = "[Snip]",
                            buffer   = "[Buf]",
                            path     = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
            })
        end,
    },
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    python = { "black" },
                },
                format_on_save = {
                    timeout_ms = 1000,
                    lsp_fallback = true,
                },
            })
        end,
    },
    -- LSP
    { "mason-org/mason.nvim",           version = "^1.0.0" },
    { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
    },
    -- No more neovim/nvim-lspconfig here!



    -- tailwind-tools.lua
    {
        "luckasRanarison/tailwind-tools.nvim",
        name = "tailwind-tools",
        build = ":UpdateRemotePlugins",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim", -- optional
            -- "neovim/nvim-lspconfig",         -- optional
        },
        opts = {} -- your configuration
    },
    -- Git signs in the gutter


    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    section_separators = "",
                    component_separators = "",
                },
            })
        end,
    }, -- Diagnostics / quickfix lis

    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Global keymaps setup using LspAttach autocmd
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    local map = function(mode, lhs, rhs, opts)
                        opts = opts or {}
                        opts.buffer = ev.buf
                        vim.keymap.set(mode, lhs, rhs, opts)
                    end

                    map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
                    map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
                    map("n", "gr", vim.lsp.buf.references, { desc = "References" })
                    map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
                end,
            })

            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "ts_ls", "pyright" },
            })
            -- Auto-start LSP servers when opening files
            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'python',
                callback = function()
                    vim.lsp.start({
                        name = 'pyright',
                        cmd = { 'pyright-langserver', '--stdio' },
                        root_dir = vim.fs.dirname(vim.fs.find({ 'pyproject.toml', 'setup.py', '.git' }, { upward = true })
                            [1]) or vim.fn.getcwd(),
                        capabilities = capabilities,
                        settings = {
                            python = {
                                analysis = {
                                    autoSearchPaths = true,
                                    useLibraryCodeForTypes = true,
                                    diagnosticMode = "workspace",
                                    typeCheckingMode = "basic",
                                },
                            },
                        },
                    })
                end,
            })

            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'lua',
                callback = function()
                    vim.lsp.start({
                        name = 'lua_ls',
                        cmd = { 'lua-language-server' },
                        root_dir = vim.fs.dirname(vim.fs.find(
                            { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml',
                                'selene.yml', '.git' }, { upward = true })[1]) or vim.fn.getcwd(),
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = { globals = { "vim" } },
                                workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                                telemetry = { enable = false },
                            },
                        },
                    })
                end,
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
                callback = function()
                    vim.lsp.start({
                        name = "tailwindcss",
                        cmd = { "tailwindcss-language-server", "--stdio" },
                        root_dir = vim.fs.dirname(
                            vim.fs.find({
                                "tailwind.config.js",
                                "tailwind.config.cjs",
                                "tailwind.config.ts",
                                "postcss.config.js",
                                "package.json",
                                ".git"
                            }, { upward = true })[1]
                        ) or vim.fn.getcwd(),
                        capabilities = capabilities, -- reuse your existing `capabilities`
                        on_init = function(client)
                            -- optional: disable formatting if you prefer prettier/eslint
                            client.server_capabilities.documentFormattingProvider = false
                            client.server_capabilities.documentRangeFormattingProvider = false
                        end,
                    })
                end,
            })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
                callback = function()
                    vim.lsp.start({
                        name = "ts_ls",
                        cmd = { "typescript-language-server", "--stdio" },
                        root_dir = vim.fs.dirname(
                            vim.fs.find({ "tsconfig.json", "jsconfig.json", "package.json", ".git" }, { upward = true })
                            [1]
                        ) or vim.fn.getcwd(),
                        capabilities = capabilities,
                        on_init = function(client)
                            -- optional: let prettier/eslint handle formatting
                            client.server_capabilities.documentFormattingProvider = false
                            client.server_capabilities.documentRangeFormattingProvider = false
                        end,
                        init_options = {
                            preferences = {
                                disableSuggestions = false, -- set true if you only want completions from nvim-cmp, not tsserver
                            }
                        }
                    })
                end,
            })
        end,
    },

})
