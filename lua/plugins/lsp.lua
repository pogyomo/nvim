return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        dependencies = {
            "Bilal2453/luvit-meta",
        },
        opts = {
            library = {
                "luvit-meta/library",
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "stevearc/conform.nvim",
        },
        config = function()
            -- Keymaps for lsp actions
            -- reference: https://zenn.dev/botamotch/articles/21073d78bc68bf
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("register-lsp-keymaps", {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf }

                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "gf", function()
                        require("conform").format { async = true }
                    end, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
                    vim.keymap.set("n", "gn", vim.lsp.buf.rename, opts)
                    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "ge", vim.diagnostic.open_float, opts)
                    vim.keymap.set("n", "g]", function()
                        vim.diagnostic.jump { count = 1 }
                    end, opts)
                    vim.keymap.set("n", "g[", function()
                        vim.diagnostic.jump { count = -1 }
                    end, opts)
                end,
            })

            -- Diagnostic
            vim.diagnostic.config {
                virtual_text = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.INFO] = "",
                        [vim.diagnostic.severity.HINT] = "",
                    },
                },
                severity_sort = true,
            }

            -- Add capabilities for all server.
            vim.lsp.config("*", {
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })

            -- Install and enable servers
            require("mason-lspconfig").setup {
                automatic_enable = true,
                automatic_installation = false,
                ensure_installed = {
                    "clangd",
                    "cmake",
                    "cssls",
                    "eslint",
                    "html",
                    "jsonls",
                    "lua_ls",
                    "pylsp",
                    "rust_analyzer",
                    "ts_ls",
                },
                handlers = {
                    function(name)
                        vim.lsp.enable(name)
                    end,
                },
            }

            -- gdscript server is provided by godot itself, so just enable here.
            vim.lsp.enable("gdscript")
        end,
    },
}
