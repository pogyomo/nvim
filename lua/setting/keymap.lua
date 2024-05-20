-- Register space as leader key.
vim.g.mapleader = " "

-- Entry point for some operation.
vim.keymap.set("n", "<Leader>t", "<Plug>(core-tab-manager)", {
    remap = true,
    desc = "entry point for tab management",
})
vim.keymap.set("n", "<Leader>w", "<Plug>(core-window-manager)", {
    remap = true,
    desc = "entry point for window management",
})
vim.keymap.set("n", "<Leader>s", "<Plug>(core-window-splitter)", {
    remap = true,
    desc = "entry point for splitting window",
})
vim.keymap.set("n", "<Leader>e", "<Plug>(core-buffer-manager)", {
    remap = true,
    desc = "entry point for buffer management",
})

-- Keymaps to manage tabs
vim.keymap.set("n", "<Plug>(core-tab-manager)h", "gT", {
    desc = "go to previous tab",
})
vim.keymap.set("n", "<Plug>(core-tab-manager)l", "gt", {
    desc = "go to next tab",
})
vim.keymap.set("n", "<Plug>(core-tab-manager)H", "<cmd>-tabmove<cr>", {
    desc = "move current tab to the left",
})
vim.keymap.set("n", "<Plug>(core-tab-manager)L", "<cmd>+tabmove<cr>", {
    desc = "move current tab to the right",
})

-- Keymaps to move around windows
vim.keymap.set("n", "<Plug>(core-window-manager)h", "<C-w>h", {
    desc = "go to left window",
})
vim.keymap.set("n", "<Plug>(core-window-manager)j", "<C-w>j", {
    desc = "go to bottom window",
})
vim.keymap.set("n", "<Plug>(core-window-manager)k", "<C-w>k", {
    desc = "go to top window",
})
vim.keymap.set("n", "<Plug>(core-window-manager)l", "<C-w>l", {
    desc = "go to right window",
})
vim.keymap.set("n", "<Plug>(core-window-manager)H", "<C-w>h", {
    desc = "move current window to left",
})
vim.keymap.set("n", "<Plug>(core-window-manager)J", "<C-w>j", {
    desc = "move current window to bottom",
})
vim.keymap.set("n", "<Plug>(core-window-manager)K", "<C-w>k", {
    desc = "move current window to top",
})
vim.keymap.set("n", "<Plug>(core-window-manager)L", "<C-w>l", {
    desc = "move current window to right",
})

-- Keymaps to split window
vim.keymap.set("n", "<Plug>(core-window-splitter)h", "<cmd>top vsplit<cr>", {
    desc = "split current window to left",
})
vim.keymap.set("n", "<Plug>(core-window-splitter)j", "<cmd>below split<cr>", {
    desc = "split current window to bottom",
})
vim.keymap.set("n", "<Plug>(core-window-splitter)k", "<cmd>top split<cr>", {
    desc = "split current window to top",
})
vim.keymap.set("n", "<Plug>(core-window-splitter)l", "<cmd>below vsplit<cr>", {
    desc = "split current window to right",
})
vim.keymap.set("n", "<Plug>(core-window-splitter)H", "<cmd>top vnew<cr>", {
    desc = "create a new window to left",
})
vim.keymap.set("n", "<Plug>(core-window-splitter)J", "<cmd>below new<cr>", {
    desc = "create a new window to bottom",
})
vim.keymap.set("n", "<Plug>(core-window-splitter)K", "<cmd>top new<cr>", {
    desc = "create a new window to top",
})
vim.keymap.set("n", "<Plug>(core-window-splitter)L", "<cmd>below vnew<cr>", {
    desc = "create a new window to right",
})

-- Keymaps to manage buffers
vim.keymap.set("n", "<Plug>(core-buffer-manager)h", "<cmd>bprev<cr>", {
    desc = "go to previous buffer",
})
vim.keymap.set("n", "<Plug>(core-buffer-manager)l", "<cmd>bnext<cr>", {
    desc = "go to next buffer",
})
vim.keymap.set("n", "<Plug>(core-buffer-manager)d", "<cmd>bdelete<cr>", {
    desc = "delete current buffer",
})

-- Keymaps to move display line.
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- Keymaps to leave from insert mode.
vim.keymap.set("i", "jj", "<ESC>", {
    desc = "leave from insert mode",
})
