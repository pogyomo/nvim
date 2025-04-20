return {
    {
        "lewis6991/gitsigns.nvim",
        opts = {},
    },
    {
        "NeogitOrg/neogit",
        branch = "master",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        cmd = {
            "Neogit",
            "NeogitResetState",
        },
        opts = {},
    },
}
