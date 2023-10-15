return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        ensure_installed = {
            "bibtex",
            "c",
            "cpp",
            "go",
            "java",
            "latex",
            "lua",
            "markdown",
            "rust",
            "toml",
            "typescript",
            "vimdoc",
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
        }
    },
    config = function(_, opts)
        local module = require("utils.module")
        local mods   = module.require {
            "nvim-treesitter.configs"
        }

        mods["nvim-treesitter.configs"].setup(opts)
    end
}
