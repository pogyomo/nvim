return {
    "windwp/nvim-autopairs",
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
}
