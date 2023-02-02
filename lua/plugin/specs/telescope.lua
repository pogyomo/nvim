return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons"
    },
    cmd = "Telescope",
    opts = {
        defaults = {
            winblend = 10
        }
    }
}
