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
    main = "nvim-treesitter.configs",
    opts = {
        ensure_installed = {
            "c",
            "cpp",
            "css",
            "html",
            "java",
            "javascript",
            "json",
            "lua",
            "markdown",
            "php",
            "phpdoc",
            "query",
            "rust",
            "sql",
            "toml",
            "typescript",
            "vimdoc",
            "zig",
        },

        -- NOTE:
        -- Indentation in php comment broken, so use regex based one.

        highlight = {
            enable = true,
            additional_vim_regex_highlighting = { "php" },
        },

        indent = {
            enable = true,
            disable = { "php" },
        },
    },
}
