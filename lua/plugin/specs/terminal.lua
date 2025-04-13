return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        {
            "<C-t>",
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
        require("toggleterm").setup()

        local terminal = require("toggleterm.terminal").Terminal
        local floatterm = terminal:new {
            direction = "float",
            float_opts = {
                border = "rounded",
            },
        }
        vim.keymap.set({ "n", "t" }, "<C-t>", function()
            floatterm:toggle()
        end, {
            desc = "toggle floating terminal",
        })
    end,
}
