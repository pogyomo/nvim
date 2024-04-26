return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "folke/neodev.nvim",
    },
    config = function()
        local module = require("utils.module")
        local mods = module.require {
            "lspconfig",
            "mason-lspconfig",
            "cmp_nvim_lsp",
            "neodev",
        }

        -- Keymaps for lsp actions
        -- reference: https://zenn.dev/botamotch/articles/21073d78bc68bf
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("register-lsp-keymaps", {}),
            callback = function(ev)
                local opts = { buffer = ev.buf }

                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gf", function()
                    vim.lsp.buf.format { async = true }
                end, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
                vim.keymap.set("n", "gn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "ge", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "g]", vim.diagnostic.goto_next, opts)
                vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, opts)
            end,
        })

        -- Setup neodev before lspconfig
        mods["neodev"].setup()

        -- Specify lsps to install
        mods["mason-lspconfig"].setup {
            ensure_installed = {
                "clangd",
                "lua_ls",
                "rust_analyzer",
                "denols",
            },
        }

        -- Default config of each lsp.
        local capabilities = mods["cmp_nvim_lsp"].default_capabilities()

        -- mason-lspconfig doesn't manage gdscript, so manually configure the lsp.
        mods["lspconfig"].gdscript.setup {
            capabilities = capabilities,
            -- FIXME: If we write this using vim.lsp.rpc.connect instead of using `ncat`, this doesn't works well.
            cmd = { "ncat", "127.0.0.1", "6005" },
        }

        mods["mason-lspconfig"].setup_handlers {
            function(name)
                mods["lspconfig"][name].setup {
                    capabilities = capabilities,
                }
            end,
            ["lua_ls"] = function()
                mods["lspconfig"].lua_ls.setup {
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                            runtime = {
                                version = "LuaJIT",
                            },
                            diagnostics = {
                                globals = { "vim" },
                            },
                        },
                    },
                }
            end,
            ["rust_analyzer"] = function()
                mods["lspconfig"].rust_analyzer.setup {
                    capabilities = capabilities,
                    settings = {
                        ["rust-analyzer"] = {
                            check = {
                                command = "clippy",
                            },
                        },
                    },
                }
            end,
        }
    end,
}
