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
                { "utils.window.move", as = "move" },
            }

            vim.keymap.set("n", "<Leader>r", "<Plug>(submode-win-resizer)")

            mods["submode"].setup()

            local is_precise = false
            local is_move = false
            mods["submode"].create("WinManipulator", {
                mode = "n",
                mode_name = function()
                    local mode_name = is_move and "WinMove" or "WinResize"
                    local postfix = is_precise and " - precise" or ""
                    return ("%s%s"):format(mode_name, postfix)
                end,
                enter = "<Plug>(submode-win-resizer)",
                leave = { "q", "<ESC>" },
                leave_cb = function()
                    is_precise = false
                    is_move = false
                end,
            }, {
                lhs = { "i", "r" },
                rhs = function(lhs)
                    if lhs == "i" then
                        is_precise = not is_precise
                    else
                        is_move = not is_move
                    end
                end,
            }, {
                lhs = { "l", "h", "j", "k" },
                rhs = function(lhs)
                    local diff_row = is_precise and 1 or 2
                    local diff_col = is_precise and 1 or 5
                    local key_to_dir = {
                        ["l"] = "right",
                        ["h"] = "left",
                        ["j"] = "down",
                        ["k"] = "up",
                    }
                    if is_move then
                        mods["move"](0, diff_row, diff_col, key_to_dir[lhs])
                    else
                        mods["resize"](0, diff_row, diff_col, key_to_dir[lhs])
                    end
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
