return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
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
    init = function()
        ---@diagnostic disable-next-line
        vim.ui.select = function(...)
            require("lazy").load { plugins = { "telescope.nvim" } }
            vim.ui.select(...)
        end
    end,
    config = function()
        require("telescope").setup {
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {},
                },
            },
            defaults = {
                winblend = 10,
                mappings = {
                    i = {
                        ["<esc>"] = require("telescope.actions").close,
                    },
                },
            },
        }
        require("telescope").load_extension("ui-select")
    end,
}
