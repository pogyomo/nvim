-- Register space as leader key.
vim.g.mapleader = " "

-- Alias of keymaps
vim.keymap.set("n", "<Leader>t", "<Plug>(core-tab-manager)", { remap = true })
vim.keymap.set("n", "<Leader>w", "<Plug>(core-window-manager)", { remap = true })
vim.keymap.set("n", "<Leader>s", "<Plug>(core-window-spliter)", { remap = true })

-- Keymaps to manage tabs
for _, key in ipairs { "l", "h" } do
    vim.keymap.set("n", "<Plug>(core-tab-manager)" .. key, function()
        return key == "l" and "gt" or "gT"
    end, { expr = true })
end
for _, key in ipairs { "L", "H" } do
    vim.keymap.set("n", "<Plug>(core-tab-manager)" .. key, function()
        return ("<cmd>%stabmove<cr>"):format(key == "L" and "+" or "-")
    end, { expr = true })
end

-- Keymaps to move around windows
for _, key in ipairs { "l", "h", "j", "k", "L", "H", "J", "K" } do
    vim.keymap.set("n", "<Plug>(core-window-manager)" .. key, "<C-w>" .. key)
end

-- Keymaps to split window
for _, key in ipairs { "l", "h", "j", "k" } do
    vim.keymap.set("n", "<Plug>(core-window-spliter)" .. key, function()
        local prefix = (key == "h" or key == "l") and "v" or ""
        return ("<cmd>%ssp<cr><C-w>%s"):format(prefix, key)
    end, { expr = true })
end

-- Keymaps to move display line.
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- Keymaps to leave from insert mode.
vim.keymap.set("i", "jj", "<ESC>")
