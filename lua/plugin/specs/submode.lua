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

        mods["submode"]:setup()

        vim.keymap.set("n", "<Leader>l", "<Plug>(submode-lsp-operator)", { remap = true })

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
