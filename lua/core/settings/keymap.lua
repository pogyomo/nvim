vim.keymap.set("i", "jj", "<ESC>")
for _, key in ipairs({ "l", "h", "j", "k" }) do
    vim.keymap.set("n", "<Space>w" .. key, "<C-w>" .. key)
end
