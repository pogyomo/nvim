return {
    {
        "folke/todo-comments.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            keywords = {
                REVIEW = { icon = " ", color = "info" },
                CHANGED = { icon = " ", color = "hint" },
            },
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            scope = {
                enabled = false,
            },
        },
    },
    {
        "rcarriga/nvim-notify",
        opts = {
            timeout = 1000,
            fps = 60,
            stages = "fade",
        },
        config = function(_, opts)
            local module = require("utils.module")
            local mods = module.require {
                "notify",
            }

            mods["notify"].setup(opts)
            vim.notify = mods["notify"]
        end,
    },
    {
        "thentenaar/vim-syntax-obscure",
        ft = { "nesasm", "ca65", "ophis", "ti99asm" },
    },
    {
        "stevearc/dressing.nvim",
        opts = {},
    },
    {
        "HiPhish/rainbow-delimiters.nvim",
    },
    {
        "j-hui/fidget.nvim",
        opts = {},
    },
    {
        "folke/tokyonight.nvim",
        opts = { style = "storm" },
        config = function(_, opts)
            local module = require("utils.module")
            local mods = module.require {
                "tokyonight",
            }

            mods["tokyonight"].setup(opts)
            vim.cmd.colorscheme("tokyonight")
        end,
    },
}
