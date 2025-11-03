local helper = require("helpers.settings")
local global_settings = helper.get_global_settings()
local ft_settings = helper.get_ft_settings()

--- Set indent style by settings.json
---
--- @param setting table Settings.
--- @param buf ?integer nil for global
local function set_indent_style(setting, buf)
    local o = buf and vim.bo[buf] or vim.o
    o.softtabstop = setting["indent"]["size"]
    o.shiftwidth = setting["indent"]["size"]
    o.tabstop = setting["indent"]["size"]
    o.expandtab = setting["indent"]["style"] == "space" and true or false
    o.cindent = true
end

-- Tab and indent
set_indent_style(global_settings)
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("set-indent-style", {}),
    callback = function(arg)
        local bo = vim.bo[arg.buf]
        for fts, setting in pairs(ft_settings) do
            for _, ft in ipairs(fts) do
                if ft == bo.filetype then
                    set_indent_style(setting, arg.buf)
                end
            end
        end
    end,
})

-- Diagnostic
vim.diagnostic.config {
    virtual_text = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
    },
    severity_sort = true,
}

-- Disable mouse
vim.o.mouse = ""

-- Config minimal spaces between cursor and top/bottom.
vim.o.scrolloff = 5

-- Visual
vim.o.showcmd = false
vim.o.number = true
vim.o.cursorline = true
vim.o.termguicolors = true
vim.o.signcolumn = "yes"

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Set maximum height of completion menu
vim.o.pumheight = 10

-- No splash screen
vim.opt.shm:append("I")

-- Automatically clear hlsearch
-- from https://www.reddit.com/r/neovim/comments/1ct2w2h/lua_adaptation_of_vimcool_auto_nohlsearch
local auto_hlsearch = vim.api.nvim_create_augroup("auto-hlsearch", {})
vim.api.nvim_create_autocmd("CursorMoved", {
    group = auto_hlsearch,
    callback = function()
        if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
            vim.schedule(function()
                vim.cmd.nohlsearch()
            end)
        end
    end,
})
vim.api.nvim_create_autocmd("InsertEnter", {
    group = auto_hlsearch,
    callback = function()
        if vim.v.hlsearch == 1 then
            vim.schedule(function()
                vim.cmd.nohlsearch()
            end)
        end
    end,
})

-- Folding
vim.o.foldmethod = "marker"

-- Better vim.ui.input
---@diagnostic disable-next-line
vim.ui.input = function(opts, on_confirm)
    local buf = vim.api.nvim_create_buf(false, true)
    if opts.default then
        vim.api.nvim_buf_set_lines(buf, 0, 1, true, { opts.default })
    end
    vim.api.nvim_create_autocmd("BufWinEnter", {
        group = vim.api.nvim_create_augroup("vim.ui.input", {}),
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
