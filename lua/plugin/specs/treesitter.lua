return {
    "nvim-treesitter/nvim-treesitter",
    build = function()
        require("nvim-treesitter.install").update{
            with_sync = true
        }()
    end,
    dependencies = {
        -- TODO: This plugin was archived, so I need to find alternative plugin like this.
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
            enable = true,
            disable = function(lang, bufnr)
                -- NOTE: I need to disable treesitter on command window.
                --       See: https://github.com/nvim-treesitter/nvim-treesitter/issues/3961
                local bufname = vim.api.nvim_buf_get_name(bufnr)
                return lang == "vim" and bufname:match("%[Command Line%]")
            end
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
