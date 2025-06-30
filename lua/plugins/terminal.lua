return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        {
            "<C-t>",
            "<cmd>ToggleTerm direction=float<cr>",
            mode = { "n", "t" },
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
    opts = {},
}
