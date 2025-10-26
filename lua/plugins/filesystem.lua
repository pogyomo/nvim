return {
    "stevearc/oil.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    keys = {
        {
            "<C-e>",
            function()
                require("oil").toggle_float()
            end,
            mode = "n",
        },
    },
    opts = {
        view_options = {
            show_hidden = true,
        },
        float = {
            border = "rounded",
        },
        confirmation = {
            border = "rounded",
        },
        progress = {
            border = "rounded",
        },
        ssh = {
            border = "rounded",
        },
        keymaps_help = {
            border = "rounded",
        },
        keymaps = {
            ["<esc>"] = { "actions.close", mode = "n" },
            ["q"] = { "actions.close", mode = "n" },
        },
    },
}
