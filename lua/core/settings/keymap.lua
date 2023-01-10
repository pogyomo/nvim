-- Alias keymaps
vim.g.mapleader = " "
vim.keymap.set("n", "<Leader>t", "[Tab]",    { remap = true })
vim.keymap.set("n", "<Leader>w", "[Window]", { remap = true })
vim.keymap.set("n", "<Leader>s", "[Split]",  { remap = true })

-- Keymaps to manage tabs
for _, key in ipairs({ "l", "h" }) do
    vim.keymap.set("n", "[Tab]" .. key, function()
        return key == "l" and "gt" or "gT"
    end, { expr = true })
end
for _, key in ipairs({ "L", "H" }) do
    vim.keymap.set("n", "[Tab]" .. key, function()
        return ("<cmd>%stabmove<cr>"):format(key == "L" and "+" or "-")
    end, { expr = true })
end

-- Keymaps to manage windows
for _, key in ipairs({ "l", "h", "j", "k", "L", "H", "J", "K" }) do
    vim.keymap.set("n", "[Window]" .. key, "<C-w>" .. key)
end

-- Keymaps to split window
for _, key in ipairs({ "l", "h", "j", "k" }) do
    vim.keymap.set("n", "[Split]" .. key, function()
        local prefix = (key == "h" or key == "l") and "v" or ""
        return ("<cmd>%ssp<cr><C-w>%s"):format(prefix, key)
    end, { expr = true })
end

-- Keymaps to leave from insert mode
vim.keymap.set("i", "jj", "<ESC>")
