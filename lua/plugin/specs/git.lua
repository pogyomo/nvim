return {
    "NeogitOrg/neogit",
    branch = "master",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "nvim-telescope/telescope.nvim",
    },
    opts = {},
    config = function(_, opts)
        local module = require("utils.module")
        local mods = module.require {
            "neogit",
        }

        -- Temporary solution for https://github.com/NeogitOrg/neogit/issues/1285
        vim.o.splitbelow = true

        mods["neogit"].setup(opts)
    end,
}
