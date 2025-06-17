return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    branch = "0.1.x",
    cmd = "Telescope",
    keys = {
        {
            "<Leader>ff",
            "<cmd>Telescope find_files<cr>",
            mode = "n",
        },
        {
            "<Leader>fg",
            "<cmd>Telescope live_grep<cr>",
            mode = "n",
        },
        {
            "<Leader>fb",
            "<cmd>Telescope buffers<cr>",
            mode = "n",
        },
        {
            "<Leader>fh",
            "<cmd>Telescope help_tags<cr>",
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
