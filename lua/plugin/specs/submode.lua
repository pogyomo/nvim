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
            rhs = vim.lsp.buf.definition
        }, {
            lhs = "D",
            rhs = vim.lsp.buf.declaration
        }, {
            lhs = "H",
            rhs = vim.lsp.buf.hover
        }, {
            lhs = "i",
            rhs = vim.lsp.buf.implementation
        }, {
            lhs = "r",
            rhs = vim.lsp.buf.references
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
