return {
    "folke/tokyonight.nvim",
    opts = { style = "storm" },
    config = function(_, opts)
        local module = require("utils.module")
        local mods   = module.require{
            "tokyonight"
        }

        mods["tokyonight"].setup(opts)
        vim.cmd.colorscheme("tokyonight")
    end
}
