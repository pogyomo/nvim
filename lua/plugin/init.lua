local is_after_install = require("utils.install").install_packer()

vim.api.nvim_create_augroup("__packer_menu", {})
vim.api.nvim_create_autocmd("FileType", {
    group = "__packer_menu",
    pattern = "packer",
    callback = function()
        vim.opt.winblend = 10
    end
})

vim.cmd.packadd("packer.nvim")
require("packer").startup({
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

        -- Utility
        use("lewis6991/impatient.nvim")

        -- Install above plugins automatically.
        if is_after_install then
            require("packer").sync()
        end
    end,
    config = {
        display = {
            open_fn = function()
                return require("packer.util").float({
                    border = "rounded"
                })
            end
        }
    }
})
