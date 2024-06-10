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
        lazy = true,
        opts = {
            timeout = 1000,
            fps = 60,
            stages = "fade",
        },
        init = function()
            ---@diagnostic disable-next-line
            vim.notify = function(...)
                require("lazy").load { plugins = { "nvim-notify" } }
                return require("notify")(...)
            end
        end,
    },
    {
        "thentenaar/vim-syntax-obscure",
        ft = { "nesasm", "ca65", "ophis", "ti99asm" },
    },
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line
            vim.ui.input = function(...)
                require("lazy").load { plugins = { "dressing.nvim" } }
                return vim.ui.input(...)
            end
            ---@diagnostic disable-next-line
            vim.ui.select = function(...)
                require("lazy").load { plugins = { "dressing.nvim" } }
                return vim.ui.select(...)
            end
        end,
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
            require("tokyonight").setup(opts)
            vim.cmd.colorscheme("tokyonight")
        end,
    },
}
