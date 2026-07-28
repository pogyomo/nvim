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
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        cmd = {
            "Neogit",
            "NeogitResetState",
        },
        opts = {
            graph_style = "unicode",
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
                },
            },
        },
    },
}
