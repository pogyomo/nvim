-- Tab and indent
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.cindent = true

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
