return {
    {
        "lewis6991/gitsigns.nvim",
        keys = {
            {
                "]c",
                "<cmd>Gitsigns next_hunk<cr>",
                mode = "n",
            },
            {
                "[c",
                "<cmd>Gitsigns prev_hunk<cr>",
                mode = "n",
            },
        },
        opts = {},
    },
    {
        "NeogitOrg/neogit",
        branch = "master",
        dependencies = {
            "folke/tokyonight.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        cmd = {
            "Neogit",
            "NeogitResetState",
        },
        opts = {},
        config = function()
            local colors = require("tokyonight.colors").setup()
            require("neogit").setup {
                use_per_project_settings = false,
                graph_style = "kitty",
                highlight = {
                    -- NOTE:
                    -- tokyonight.nvim support neogit, but its definitions seem to be incomplete.
                    -- Provide colors manually so it will be more colorful.
                    red = colors.red,
                    orange = colors.orange,
                    yellow = colors.yellow,
                    green = colors.green,
                    cyan = colors.cyan,
                    blue = colors.blue,
                    purple = colors.purple,
                },
                mappings = {
                    -- Use neovim's default features to edit rebase items
                    rebase_editor = {
                        ["r"] = false,
                        ["e"] = false,
                        ["s"] = false,
                        ["f"] = false,
                        ["x"] = false,
                        ["d"] = false,
                        ["b"] = false,
                        ["p"] = false,
                    },
                },
            }
        end,
    },
}
