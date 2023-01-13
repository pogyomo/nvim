return {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    build = function()
        require("nvim-treesitter.install").update{
            with_sync = true
        }()
    end,
    dependencies = {
        "p00f/nvim-ts-rainbow"
    },
    opts = {
        ensure_installed = {
            "bibtex",
            "c",
            "cpp",
            "go",
            "help",
            "java",
            "lua",
            "latex",
            "markdown",
            "typescript",
            "rust",
            "zig"
        },

        highlight = {
            enable = true
        },

        rainbow = {
            enable = true,
            extended_mode = true
        }
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end
}
