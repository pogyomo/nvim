return {
    "NeogitOrg/neogit",
    branch = "master",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "nvim-telescope/telescope.nvim",
    },
    cmd = {
        "Neogit",
        "NeogitResetState",
    },
    opts = {},
    config = function(_, opts)
        local module = require("utils.module")
        local mods = module.require {
            "neogit",
        }

        -- Temporary solution for https://github.com/NeogitOrg/neogit/issues/1285
        local group = vim.api.nvim_create_augroup("neogit-temp-solution", {})
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
            group = group,
            pattern = "Neogit*",
            callback = function()
                vim.o.splitbelow = true
            end,
        })
        vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave" }, {
            group = group,
            pattern = "Neogit*",
            callback = function()
                vim.o.splitbelow = false
            end,
        })

        mods["neogit"].setup(opts)
    end,
}
