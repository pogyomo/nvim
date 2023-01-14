return {
    {
        "folke/todo-comments.nvim",
        opts = {
            keywords = {
                REVIEW =  { icon = " ", color = "info" },
                CHANGED = { icon = " ", color = "hint" }
            }
        },
        config = function(_, opts)
            local module = require("utils.module")
            local mods = module.require{
                "todo-comments"
            }

            vim.o.signcolumn = "yes"
            mods["todo-comments"].setup(opts)
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = true
    },
    {
        "rcarriga/nvim-notify",
        opts = {
            timeout = 1000,
            fps     = 60,
            stages  = "fade"
        },
        config = function(_, opts)
            local module = require("utils.module")
            local mods = module.require{
                "notify"
            }
            mods["notify"].setup(opts)
            vim.notify = mods["notify"]
        end
    },
    {
        "sainnhe/sonokai",
        config = function()
            -- Change the style of this colorscheme.
            vim.g.sonokai_style = "shusia"

            -- Disable italic.
            vim.g.sonokai_enable_italic = false
            vim.g.sonokai_disable_italic_comment = true

            -- Make virtual text to be colorful.
            vim.g.sonokai_diagnostic_virtual_text = "colored"

            -- Reduce the loading time.
            vim.g.sonokai_better_performance = true

            -- Load this colorscheme
            vim.cmd.colorscheme("sonokai")
        end
    },
    {
        "thentenaar/vim-syntax-obscure",
        ft = { "nesasm", "ca65", "ophis", "ti99asm" }
    }
}
