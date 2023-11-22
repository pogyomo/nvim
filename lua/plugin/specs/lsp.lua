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
            { "utils.lsp.progress.hover", as = "progress-hover" },
            "neodev",
        }

        -- Setup neodev before lspconfig
        mods["neodev"].setup()

        mods["progress-hover"].setup()

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
        }
    end,
}
