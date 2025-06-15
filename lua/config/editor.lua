local helper = require("helpers.settings")
local settings = helper.load()
local global_settings = helper.global_settings(settings)
local ft_settings = helper.ft_settings(settings)

--- Set indent style by settings.json
---
--- @param opts table Settings.
--- @param buf ?integer nil for global
local function set_indent_style(opts, buf)
    local o = buf and vim.bo[buf] or vim.o
    o.softtabstop = opts["indent"]["size"]
    o.shiftwidth = opts["indent"]["size"]
    o.tabstop = opts["indent"]["size"]
    o.expandtab = opts["indent"]["style"] == "space" and true or false
    o.cindent = true
end

-- Tab and indent
set_indent_style(global_settings)
vim.api.nvim_create_autocmd("Filetype", {
    group = vim.api.nvim_create_augroup("set-indent-style", {}),
    callback = function(arg)
        local bo = vim.bo[arg.buf]
        if ft_settings[bo.filetype] then
            set_indent_style(ft_settings[bo.filetype], arg.buf)
        end
    end,
})

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
