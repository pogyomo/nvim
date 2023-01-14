return {
    "pogyomo/submode.nvim",
    config = function()
        local module = require("utils.module")
        local mods = module.require{
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
            return vim.api.nvim_win_get_number(right) == vim.api.nvim_win_get_number(window)
        end

        vim.keymap.set("n", "<Leader>l", "<Plug>(submode-lsp-operator)", { remap = true })
        vim.keymap.set("n", "<Leader>r", "<Plug>(submode-win-resizer)",  { remap = true })

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
                local diff = 5

                if vim.fn.winlayout()[1] == "leaf" then
                    return
                end

                if lhs == "l" then
                    setter(0, getter(0) + (have_neighbor_to(0, "right") and -diff or diff))
                elseif lhs == "h" then
                    setter(0, getter(0) + (have_neighbor_to(0, "right") and diff or -diff))
                elseif lhs == "j" then
                    setter(0, getter(0) + (have_neighbor_to(0, "down")  and -diff or diff))
                else
                    setter(0, getter(0) + (have_neighbor_to(0, "down")  and diff or -diff))
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
            pattern = "*",
            callback = function(opt)
                if vim.opt.ft:get() == "help" then
                    if opt.event == "BufEnter" then
                        mods["submode"]:enter("DocReader")
                    else
                        mods["submode"]:leave()
                    end
                end
            end
        })
    end
}
