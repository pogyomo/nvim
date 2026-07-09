return {
    {
        "lewis6991/gitsigns.nvim",
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
}
