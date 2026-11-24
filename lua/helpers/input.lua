local M = {}

--- Drop-in replacement of vim.ui.input
--- @param opts vim.ui.input.Opts?
--- @param on_confirm fun(input: string?)
function M.input(opts, on_confirm)
    local buf = vim.api.nvim_create_buf(false, true)
    if opts.default then
        vim.api.nvim_buf_set_lines(buf, 0, 1, true, { opts.default })
    end
    vim.api.nvim_create_autocmd("BufWinEnter", {
        group = vim.api.nvim_create_augroup("pogyomo.enter_insert", {}),
        callback = function(ev)
            if ev.buf == buf then
                vim.api.nvim_input("A")
            end
        end,
    })

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "cursor",
        row = -3,
        col = 0,
        width = 40,
        height = 1,
        title = opts.prompt or "input",
        border = "rounded",
        style = "minimal",
    })

    local finalize = function()
        vim.api.nvim_win_close(win, true)
        if not vim.api.nvim_get_mode().mode:match("^n") then
            vim.api.nvim_input("<esc>")
            vim.api.nvim_input("l")
        else
            vim.api.nvim_input("<esc>")
        end
    end

    local confirm_cb = function()
        local input = vim.api.nvim_buf_get_lines(buf, 0, 1, true)[1]
        finalize()
        on_confirm(input)
    end

    local discard_cb = function()
        finalize()
        on_confirm()
    end

    vim.keymap.set("i", "<Enter>", confirm_cb, { buffer = buf })
    vim.keymap.set("n", "<Enter>", confirm_cb, { buffer = buf })
    vim.keymap.set("n", "<Esc>", discard_cb, { buffer = buf })
end

return M
