return {
    "williamboman/mason.nvim",
    opts = {
        ui = {
            border = "rounded"
        }
    },
    config = function(_, opts)
        local module = require("utils.module")
        local mods   = module.require{
            "mason",
        }

        -- Always show signcolumn.
        vim.opt.signcolumn = "yes"

        -- Set transparency to mason's floating window.
        vim.api.nvim_create_augroup("__mason_menu", {})
        vim.api.nvim_create_autocmd("FileType", {
            group = "__mason_menu",
            pattern = "mason",
            callback = function()
                vim.opt.winblend = 10
            end
        })

        mods["mason"].setup(opts)
    end
}
