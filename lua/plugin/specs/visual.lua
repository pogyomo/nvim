return {
    {
        "folke/todo-comments.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            keywords = {
                REVIEW  = { icon = " ", color = "info" },
                CHANGED = { icon = " ", color = "hint" }
            }
        },
        config = function(_, opts)
            local module     = require("utils.module")
            local mods       = module.require {
                "todo-comments"
            }

            vim.o.signcolumn = "yes"
            mods["todo-comments"].setup(opts)
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            scope = {
                enabled = false,
            }
        },
        config = function(_, opts)
            local module = require("utils.module")
            local mods   = module.require {
                "ibl",
            }

            mods["ibl"].setup(opts)
        end
    },
    {
        "rcarriga/nvim-notify",
        opts = {
            timeout = 1000,
            fps     = 60,
            stages  = "fade"
        },
        config = function(_, opts)
            local module = require("utils.module")
            local mods   = module.require {
                "notify"
            }
            mods["notify"].setup(opts)
            vim.notify = mods["notify"]
        end
    },
    {
        "thentenaar/vim-syntax-obscure",
        ft = { "nesasm", "ca65", "ophis", "ti99asm" }
    },
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
            ---@diagnostic disable-next-line
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
        end
    },
    {
        "HiPhish/rainbow-delimiters.nvim",
        opts = {},
        config = function(_, opts)
            local module = require("utils.module")
            local mods   = module.require {
                "rainbow-delimiters.setup"
            }

            mods["rainbow-delimiters.setup"].setup(opts)
        end
    }
}
