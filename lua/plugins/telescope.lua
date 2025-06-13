return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    branch = "0.1.x",
    cmd = "Telescope",
    keys = {
        {
            "<C-P>",
            "<cmd>Telescope<cr>",
            mode = "n",
        },
    },
    opts = {
        defaults = {
            winblend = 10,
            mappings = {
                i = {
                    ["<esc>"] = require("telescope.actions").close,
                },
            },
        },
    },
}
