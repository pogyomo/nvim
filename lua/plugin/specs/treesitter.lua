return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = {
        "TSUpdate",
        "TSEnable",
        "TSToggle",
        "TSDisable",
        "TSInstall",
        "TSBufEnable",
        "TSBufToggle",
        "TSEditQuery",
        "TSUninstall",
        "TSBufDisable",
        "TSConfigInfo",
        "TSModuleInfo",
        "TSUpdateSync",
        "TSInstallInfo",
        "TSInstallSync",
        "TSInstallFromGrammar",
    },
    opts = {
        ensure_installed = {
            "bibtex",
            "c",
            "cpp",
            "go",
            "java",
            "json",
            "latex",
            "lua",
            "markdown",
            "rust",
            "toml",
            "typescript",
            "vimdoc",
            "zig",
        },

        highlight = {
            enable = true,
            disable = function(lang, bufnr)
                -- NOTE: I need to disable treesitter on command window.
                --       See: https://github.com/neovim/neovim/issues/26346
                local bufname = vim.api.nvim_buf_get_name(bufnr)
                return lang == "vim" and bufname:match("%[Command Line%]")
            end,
        },

        -- Enable this for fixing indentation at some language.
        -- reference: https://zenn.dev/uga_rosa/articles/9eb5063f8f9b75
        indent = {
            enable = true,
        },
    },
    config = function(_, opts)
        local module = require("utils.module")
        local mods = module.require {
            "nvim-treesitter.configs",
        }

        mods["nvim-treesitter.configs"].setup(opts)
    end,
}
