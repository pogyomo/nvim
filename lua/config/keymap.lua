vim.g.mapleader = " "

-- Move around windows
vim.keymap.set("n", "<Leader>wh", "<C-w>h")
vim.keymap.set("n", "<Leader>wj", "<C-w>j")
vim.keymap.set("n", "<Leader>wk", "<C-w>k")
vim.keymap.set("n", "<Leader>wl", "<C-w>l")
vim.keymap.set("n", "<Leader>wH", "<C-w>H")
vim.keymap.set("n", "<Leader>wJ", "<C-w>J")
vim.keymap.set("n", "<Leader>wK", "<C-w>K")
vim.keymap.set("n", "<Leader>wL", "<C-w>L")

-- Split window
vim.keymap.set("n", "<Leader>sh", "<cmd>abo vsplit<cr>")
vim.keymap.set("n", "<Leader>sj", "<cmd>bel split<cr>")
vim.keymap.set("n", "<Leader>sk", "<cmd>abo split<cr>")
vim.keymap.set("n", "<Leader>sl", "<cmd>bel vsplit<cr>")
vim.keymap.set("n", "<Leader>sH", "<cmd>abo vnew<cr>")
vim.keymap.set("n", "<Leader>sJ", "<cmd>bel new<cr>")
vim.keymap.set("n", "<Leader>sK", "<cmd>abo new<cr>")
vim.keymap.set("n", "<Leader>sL", "<cmd>bel vnew<cr>")

-- Manage buffers
vim.keymap.set("n", "<Leader>eh", "<cmd>bprev<cr>")
vim.keymap.set("n", "<Leader>el", "<cmd>bnext<cr>")
vim.keymap.set("n", "<Leader>ed", "<cmd>bdelete<cr>")

-- Move over displayed lines.
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- Leave from insert mode.
vim.keymap.set("i", "jj", "<esc>", {
    desc = "leave from insert mode",
})
