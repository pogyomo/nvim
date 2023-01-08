require("utils.install.packer").install(function()
    -- NOTE: If it is a time this config installed packer,
    --       require("packer") fail. So I need to check whether
    --       it is successed or not.
    -- TODO: Is there any good solution to load packer without error
    --       when it is first time to run this config?
    local module = require("utils.module")
    local is_ok, mods = pcall(module.require, {
        "packer"
    })
    if not is_ok then
        return
    end

    mods["packer"].startup({
        function(use)
            use("wbthomason/packer.nvim")

            -- Syntax highlight
            use{
                "nvim-treesitter/nvim-treesitter",
                run = function()
                    require("nvim-treesitter.install").update{
                        with_sync = true
                    }()
                end,
                requires = {
                    {
                        "p00f/nvim-ts-rainbow",
                        cond = function()
                            return pcall(require, "nvim-treesitter")
                        end
                    }
                },
                config = require("plugin.settings.treesitter")
            }

            -- Statusline
            use{
                "nvim-lualine/lualine.nvim",
                requires = {
                    "kyazdani42/nvim-web-devicons"
                },
                config = require("plugin.settings.lualine")
            }

            -- Visual
            use{
                "sainnhe/sonokai",
                config = require("plugin.settings.sonokai")
            }
            use{
                "lukas-reineke/indent-blankline.nvim",
                config = require("plugin.settings.indent")
            }
            use{
                "rcarriga/nvim-notify",
                config = require("plugin.settings.notify")
            }
            use{
                "folke/todo-comments.nvim",
                config = require("plugin.settings.todo")
            }

            -- Package manager
            use{
                "williamboman/mason.nvim",
                requires = {
                    -- Lsp manager and utility
                    "neovim/nvim-lspconfig",
                    "williamboman/mason-lspconfig.nvim",
                    "j-hui/fidget.nvim"
                },
                config = require("plugin.settings.mason")
            }

            -- Completion
            -- FIXME: When I install nvim-cmp with lsp support, lua highlight collapse
            --        in the situation of calling passed variable inside the function.
            --        ex: function f(cb) cb() end
            use{
                "hrsh7th/nvim-cmp",
                requires = {
                    -- Snippet engine
                    "L3MON4D3/LuaSnip",

                    -- Sources
                    "hrsh7th/cmp-nvim-lsp",
                    "hrsh7th/cmp-buffer",
                    "hrsh7th/cmp-path",
                    "hrsh7th/cmp-cmdline",
                    "hrsh7th/cmp-nvim-lsp-signature-help",
                    "saadparwaiz1/cmp_luasnip",

                    -- Visual
                    "onsails/lspkind.nvim"
                },
                config = require("plugin.settings.cmp")
            }

            -- Key mapping
            use{
                "windwp/nvim-autopairs",
                config = require("plugin.settings.autopairs")
            }
        end,
        config = {
            display = {
                open_fn = require("packer.util").float
            }
        }
    })
end)
