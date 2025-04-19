-- Provide below keymaps only when reading help.
if vim.o.modifiable then
    return
end

vim.keymap.set("n", "<Enter>", "<C-]>", { buffer = 0 })
vim.keymap.set("n", "u", "<cmd>po<cr>", { buffer = 0 })
vim.keymap.set("n", "r", "<cmd>ta<cr>", { buffer = 0 })
vim.keymap.set("n", "U", "<cmd>ta<cr>", { buffer = 0 })
vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = 0 })
