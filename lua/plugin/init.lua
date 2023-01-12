require("utils.install").install_lazy()
require("lazy").setup({
    -- Syntax highlight
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            require("nvim-treesitter.install").update{
                with_sync = true
            }()
        end,
        dependencies = {
            "p00f/nvim-ts-rainbow"
        },
        config = require("plugin.settings.treesitter")
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "kyazdani42/nvim-web-devicons"
        },
        config = require("plugin.settings.lualine")
    },

    -- Visual
    {
        "sainnhe/sonokai",
        config = require("plugin.settings.sonokai")
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = require("plugin.settings.indent")
    },
    {
        "rcarriga/nvim-notify",
        config = require("plugin.settings.notify")
    },
    {
        "folke/todo-comments.nvim",
        config = require("plugin.settings.todo")
    },

    -- Package manager
    {
        "williamboman/mason.nvim",
        dependencies = {
            -- Lsp manager and utility
            "neovim/nvim-lspconfig",
            "williamboman/mason-lspconfig.nvim",
            "j-hui/fidget.nvim"
        },
        config = require("plugin.settings.mason")
    },

    -- Completion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            -- Snippet engine
            "L3MON4D3/LuaSnip",

            -- Sources
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "saadparwaiz1/cmp_luasnip",

            -- Visual
            "onsails/lspkind.nvim"
        },
        config = require("plugin.settings.cmp")
    },

    -- Key mapping
    {
        "windwp/nvim-autopairs",
        config = require("plugin.settings.autopairs")
    },

    -- Utility
    "lewis6991/impatient.nvim"
})
