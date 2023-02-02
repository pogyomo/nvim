-- FIX: When I writing rust code, sometimes diagnostics
--      don't appear.
--      This happen frequently when the crate is young.
-- FIX: After I installed new plugin, lsp throw error
--      when I writing something.
--      I think this may be caused by disabling semantic token.

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "j-hui/fidget.nvim"
    },
    config = function()
        local module = require("utils.module")
        local mods   = module.require{
            "fidget",
            "lspconfig",
            "mason-lspconfig",
            "cmp_nvim_lsp"
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

        -- Default config of each lsp.
        local capabilities = mods["cmp_nvim_lsp"].default_capabilities()
        local on_attach = function(client)
            -- NOTE: This feature may collapse syntax highlight.
            --       So, I need to disable it.
            client.server_capabilities.semanticTokensProvider = nil
        end

        mods["mason-lspconfig"].setup_handlers{
            function(name)
                mods["lspconfig"][name].setup{
                    capabilities = capabilities,
                    on_attach = on_attach
                }
            end,
            ["sumneko_lua"] = function()
                mods["lspconfig"].sumneko_lua.setup{
                    capabilities = capabilities,
                    on_attach = on_attach,
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
