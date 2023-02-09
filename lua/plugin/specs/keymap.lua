return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            local module = require("utils.module")
            local mods = module.require{
                "cmp",
                { "nvim-autopairs", as = "autopairs" },
                { "nvim-autopairs.completion.cmp", as = "autopairs_cmp" }
            }

            mods["autopairs"].setup()
            mods["cmp"].event:on(
                "confirm_done",
                mods["autopairs_cmp"].on_confirm_done()
            )
        end
    },
    {
        "pogyomo/submode.nvim",
        dev = true,
        config = function()
            local module = require("utils.module")
            local mods   = module.require{
                "submode",
                { "utils.window.resize", as = "resize" },
                { "utils.window.move",   as = "move" }
            }

            local function append_leave(map)
                return ("%s<cmd>lua require('submode'):leave()<cr>"):format(map)
            end

            vim.keymap.set("n", "<Leader>l", "<Plug>(submode-lsp-operator)")
            vim.keymap.set("n", "<Leader>r", "<Plug>(submode-win-resizer)")

            mods["submode"]:setup()

            mods["submode"]:create("LspOperator", {
                mode  = "n",
                enter = "<Plug>(submode-lsp-operator)",
                leave = { "q", "<ESC>" }
            }, {
                lhs = "d",
                rhs = function() vim.lsp.buf.definition() end
            }, {
                lhs = "D",
                rhs = function() vim.lsp.buf.declaration() end
            }, {
                lhs = "H",
                rhs = function() vim.lsp.buf.hover() end
            }, {
                lhs = "i",
                rhs = function() vim.lsp.buf.implementation() end
            }, {
                lhs = "r",
                rhs = function() vim.lsp.buf.references() end
            })

            mods["submode"]:create("WinResizer", {
                mode = "n",
                enter = "<Plug>(submode-win-resizer)",
                leave = { "q", "<ESC>" }
            }, {
                lhs = { "l", "h", "j", "k" },
                rhs = function(lhs)
                    mods["resize"](0, 2, 5, ({
                        ["l"] = "right",
                        ["h"] = "left",
                        ["j"] = "down",
                        ["k"] = "up"
                    })[lhs])
                end
            }, {
                lhs = { "<C-l>", "<C-h>", "<C-j>", "<C-k>" },
                rhs = function(lhs)
                    mods["move"](0, 2, 5, ({
                        ["<C-l>"] = "right",
                        ["<C-h>"] = "left",
                        ["<C-j>"] = "down",
                        ["<C-k>"] = "up"
                    })[lhs])
                end
            })

            mods["submode"]:create("DocReader", {
                mode = "n"
            }, {
                lhs = "<Enter>",
                rhs = "<C-]>"
            }, {
                lhs = "u",
                rhs = "<cmd>po<cr>"
            }, {
                lhs = { "r", "U" },
                rhs = "<cmd>ta<cr>"
            }, {
                lhs = "i",
                rhs = append_leave("<Insert>")
            })

            vim.api.nvim_create_augroup("DocReaderAug", {})
            vim.api.nvim_create_autocmd({
                "BufEnter", "BufLeave"
            }, {
                group = "DocReaderAug",
                callback = function(opt)
                    if vim.opt.ft:get() == "help" and opt.event == "BufEnter" then
                        mods["submode"]:enter("DocReader")
                    elseif mods["submode"]:mode() == "DocReader" then
                        mods["submode"]:leave()
                    end
                end
            })
            vim.api.nvim_create_autocmd("CmdwinEnter", {
                group = "DocReaderAug",
                callback = function()
                    if mods["submode"]:mode() == "DocReader" then
                        mods["submode"]:leave()
                    end
                end
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                group = "DocReaderAug",
                callback = function()
                    if vim.opt.ft:get() ~= "help" then
                        return
                    end
                    if mods["submode"]:mode() == "DocReader" then
                        return
                    end

                    mods["submode"]:enter("DocReader")
                end
            })
        end
    }
}
