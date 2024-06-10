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

        mods["neogit"].setup(opts)
    end,
}
