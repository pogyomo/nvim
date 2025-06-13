return {
    "stevearc/oil.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    keys = {
        {
            "<C-e>",
            function()
                require("oil").open_float()
            end,
            mode = "n",
        },
    },
    opts = {
        view_options = {
            show_hidden = true,
        },
    },
}
