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
        config = function()
            local module = require("utils.module")
            local mods   = module.require{
                "submode"
            }

            local function append_leave(map)
                return ("%s<cmd>lua require('submode'):leave()<cr>"):format(map)
            end

            local function have_neighbor_to(window, dir)
                local right = vim.api.nvim_win_call(window, function()
                    vim.cmd.wincmd(({
                        left  = "h",
                        right = "l",
                        up    = "k",
                        down  = "j"
                    })[dir])
                    return vim.api.nvim_get_current_win()
                end)
                local r_winnr = vim.api.nvim_win_get_number(right)
                local w_winnr = vim.api.nvim_win_get_number(window)
                return r_winnr == w_winnr
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
                    local dir = (lhs == "l" or lhs == "h") and "width" or "height"
                    local setter = vim.api["nvim_win_set_" .. dir]
                    local getter = vim.api["nvim_win_get_" .. dir]
                    local diff_row = 2
                    local diff_col = 5

                    if vim.api.nvim_win_get_config(0).relative ~= "" then
                        if lhs == "l" then
                            setter(0, getter(0) + diff_col)
                        elseif lhs == "h" then
                            setter(0, getter(0) - diff_col)
                        elseif lhs == "j" then
                            setter(0, getter(0) + diff_row)
                        else
                            setter(0, getter(0) - diff_row)
                        end
                        return
                    end

                    if vim.fn.winlayout()[1] == "leaf" then
                        return
                    end

                    dir = (lhs == "l" or lhs == "h") and "right" or "down"
                    if lhs == "l" then
                        setter(0, getter(0) + (have_neighbor_to(0, dir) and -diff_col or diff_col))
                    elseif lhs == "h" then
                        setter(0, getter(0) + (have_neighbor_to(0, dir) and diff_col or -diff_col))
                    elseif lhs == "j" then
                        setter(0, getter(0) + (have_neighbor_to(0, dir) and -diff_row or diff_row))
                    else
                        setter(0, getter(0) + (have_neighbor_to(0, dir) and diff_row or -diff_row))
                    end
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
                    if vim.opt.ft:get() == "help" then
                        if opt.event == "BufEnter" then
                            mods["submode"]:enter("DocReader")
                        else
                            mods["submode"]:leave()
                        end
                    elseif mods["submode"]:mode() == "DocReader" then
                        mods["submode"]:leave()
                    end
                end
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                group = "DocReaderAug",
                callback = function()
                    if vim.opt.ft:get() == "help" and mods["submode"]:mode() ~= "DocReader" then
                        mods["submode"]:enter("DocReader")
                    end
                end
            })
        end
    }
}
