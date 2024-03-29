return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        {
            "<Leader>f",
            mode = "n",
        },
    },
    cmd = {
        "ToggleTerm",
        "ToggleTermToggleAll",
        "TermExec",
        "TermSelect",
        "ToggleTermSetName",
        "ToggleTermSendCurrentLine",
        "ToggleTermSendVisualLines",
        "ToggleTermSendVisualSelection",
    },
    config = function()
        local module = require("utils.module")
        local mods = module.require {
            "toggleterm",
            "toggleterm.terminal",
        }
        local terminal = mods["toggleterm.terminal"].Terminal

        mods["toggleterm"].setup()

        local floatterm = terminal:new {
            direction = "float",
            float_opts = {
                border = "rounded",
            },
        }
        vim.keymap.set("n", "<Leader>f", function()
            floatterm:toggle()
        end, {
            desc = "toggle floating terminal",
        })
    end,
}
