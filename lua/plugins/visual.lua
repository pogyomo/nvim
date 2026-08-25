return {
    {
        "delphinus/cellwidths.nvim",
        opts = {
            name = "user/custom",
            fallback = function(cw)
                cw.load("default")
                cw.delete {
                    0x2768, -- ❨
                    0x2769, -- ❩
                    0x276a, -- ❪
                    0x276b, -- ❫
                    0x276c, -- ❬
                    0x276d, -- ❭
                    0x276e, -- ❮
                    0x276f, -- ❯
                    0x2770, -- ❰
                    0x2771, -- ❱
                    0x2772, -- ❲
                    0x2773, -- ❳
                    0x2774, -- ❴
                    0x2775, -- ❵
                }
            end,
        },
    },
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
        "HiPhish/rainbow-delimiters.nvim",
    },
    {
        "j-hui/fidget.nvim",
        opts = {
            notification = {
                override_vim_notify = true,
                window = {
                    zindex = 100,
                },
            },
        },
    },
    {
        "folke/tokyonight.nvim",
        opts = { style = "storm" },
        config = function(_, opts)
            require("tokyonight").setup(opts)
            vim.cmd.colorscheme("tokyonight")
        end,
    },
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {},
    },
}
