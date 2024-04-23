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
