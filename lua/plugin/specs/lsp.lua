return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "j-hui/fidget.nvim"
    },
    config = function()
        local module = require("utils.module")
        local mods = module.require{
            "fidget",
            "lspconfig",
            "mason-lspconfig",
            "cmp_nvim_lsp",
        }

        -- Show progress of lsp startup.
        mods["fidget"].setup()

        -- Specify lsps to install
        mods["mason-lspconfig"].setup{
            ensure_installed = {
                "clangd",
                "sumneko_lua",
                "rust_analyzer",
                "denols"
            }
        }

        -- Settings for specific lsp with nvim-cmp
        local cap = mods["cmp_nvim_lsp"].default_capabilities()
        mods["mason-lspconfig"].setup_handlers{
            function(name)
                mods["lspconfig"][name].setup{
                    capabilities = cap
                }
            end,
            ["sumneko_lua"] = function()
                mods["lspconfig"].sumneko_lua.setup{
                    capabilities = cap,
                    -- NOTE: In lua, if this feature enabled, the syntax highlight collaps.
                    --       I need to disable this while this problem alive.
                    on_attach = function(client, _)
                        client.server_capabilities.semanticTokensProvider = nil
                    end,
                    settings = {
                        Lua = {
                            runtime = {
                                version = "LuaJIT"
                            },
                            diagnostics = {
                                globals = { "vim" }
                            }
                        }
                    }
                }
            end
        }
    end
}
