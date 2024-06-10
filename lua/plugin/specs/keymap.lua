return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            local module = require("utils.module")
            local mods = module.require {
                "cmp",
                { "nvim-autopairs", as = "autopairs" },
                { "nvim-autopairs.completion.cmp", as = "autopairs_cmp" },
            }

            mods["autopairs"].setup()
            mods["cmp"].event:on(
                "confirm_done",
                mods["autopairs_cmp"].on_confirm_done()
            )
        end,
    },
    {
        "folke/flash.nvim",
        opts = {
            modes = {
                search = {
                    enabled = true,
                },
            },
        },
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        opts = {},
    },
    {
        "pogyomo/submode.nvim",
        dev = true,
        config = function()
            local module = require("utils.module")
            local mods = module.require {
                "submode",
                { "utils.window.resize", as = "resize" },
            }

            mods["submode"].setup()

            vim.keymap.set("n", "<Leader>r", "<Plug>(submode-win-resizer)")
            mods["submode"].create("WinResizer", {
                mode = "n",
                enter = "<Plug>(submode-win-resizer)",
                leave = { "q", "<ESC>" },
            }, {
                lhs = "h",
                rhs = function()
                    mods["resize"](0, 2, 2, "left")
                end,
            }, {
                lhs = "j",
                rhs = function()
                    mods["resize"](0, 2, 2, "down")
                end,
            }, {
                lhs = "k",
                rhs = function()
                    mods["resize"](0, 2, 2, "up")
                end,
            }, {
                lhs = "l",
                rhs = function()
                    mods["resize"](0, 2, 2, "right")
                end,
            })

            mods["submode"].create("DocReader", {
                mode = "n",
            }, {
                lhs = "<Enter>",
                rhs = "<C-]>",
            }, {
                lhs = "u",
                rhs = "<cmd>po<cr>",
            }, {
                lhs = { "r", "U" },
                rhs = "<cmd>ta<cr>",
            }, {
                lhs = "q",
                rhs = "<cmd>q<cr>",
            })
            vim.api.nvim_create_augroup("DocReaderAugroup", {})
            vim.api.nvim_create_autocmd("BufEnter", {
                group = "DocReaderAugroup",
                callback = function()
                    if vim.opt.ft:get() == "help" and not vim.bo.modifiable then
                        mods["submode"].enter("DocReader")
                    end
                end,
            })
            vim.api.nvim_create_autocmd({ "BufLeave", "CmdwinEnter" }, {
                group = "DocReaderAugroup",
                callback = function()
                    if mods["submode"].mode() == "DocReader" then
                        mods["submode"].leave()
                    end
                end,
            })
        end,
    },
}
