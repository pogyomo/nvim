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
                "lua_ls",
                "rust_analyzer",
                "denols"
            }
        }

        -- Default config of each lsp.
        local capabilities = mods["cmp_nvim_lsp"].default_capabilities()

        mods["mason-lspconfig"].setup_handlers{
            function(name)
                mods["lspconfig"][name].setup{
                    capabilities = capabilities
                }
            end,
            ["lua_ls"] = function()
                mods["lspconfig"].lua_ls.setup{
                    capabilities = capabilities,
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
