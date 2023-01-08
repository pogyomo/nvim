return function()
    local module = require("utils.module")
    local is_ok, mods = pcall(module.require, {
        "mason",
        "lspconfig",
        "mason-lspconfig",
        "cmp_nvim_lsp",
        "fidget"
    })
    if not is_ok then
        return
    end

    local function setup_mason()
        -- Always show signcolumn.
        vim.opt.signcolumn = "yes"

        mods["mason"].setup{
            ui = {
                border = "rounded"
            }
        }

        vim.api.nvim_create_augroup("__mason_menu", {})
        vim.api.nvim_create_autocmd("FileType", {
            group = "__mason_menu",
            pattern = "mason",
            callback = function()
                vim.opt.winblend = 10
            end
        })
    end

    local function setup_lsp()
        -- Show progress of lsp startup.
        mods["fidget"].setup()

        -- Specify lsps to install
        mods["mason-lspconfig"].setup{
            ensure_installed = {
                "clangd",
                "sumneko_lua",
                "rust_analyzer",
                "tsserver"
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
            end,
        }
    end

    setup_mason()
    setup_lsp()
end
