return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        {
            "<C-t>",
            function()
                -- See: https://github.com/akinsho/toggleterm.nvim/issues/463
                --
                -- In msys2 and if 'shell' is unix shell (like bash.exe), 'shellcmdflag' should be '-s'.
                -- But commands with '!' works correctly with '-c', so restore 'shellcmdflag' after launch terminal.
                local shellcmdflag = vim.o.shellcmdflag
                if require("modules.msys2").is_msys2_unix_shell() then
                    vim.o.shellcmdflag = "-s"
                end
                vim.cmd([[ToggleTerm direction=float]])
                vim.o.shellcmdflag = shellcmdflag
            end,
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
