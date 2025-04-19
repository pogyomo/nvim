-- Register space as leader key.
vim.g.mapleader = " "

-- Entry point for some operation.
vim.keymap.set("n", "<Leader>w", "<Plug>(core-window-manager)", {
    remap = true,
    desc = "entry point for window management",
})
vim.keymap.set("n", "<Leader>s", "<Plug>(core-window-splitter)", {
    remap = true,
    desc = "entry point for splitting window",
})
vim.keymap.set("n", "<Leader>e", "<Plug>(core-buffers)", {
    remap = true,
    desc = "entry point for buffer management",
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
vim.keymap.set("n", "<Plug>(core-window-manager)H", "<C-w>H", {
    desc = "move current window to left",
})
vim.keymap.set("n", "<Plug>(core-window-manager)J", "<C-w>J", {
    desc = "move current window to bottom",
})
vim.keymap.set("n", "<Plug>(core-window-manager)K", "<C-w>K", {
    desc = "move current window to top",
})
vim.keymap.set("n", "<Plug>(core-window-manager)L", "<C-w>L", {
    desc = "move current window to right",
})

-- Keymaps to split window
vim.keymap.set("n", "<Plug>(core-window-splitter)h", "<cmd>abo vsplit<cr>", {
    desc = "split current window to left",
})
vim.keymap.set("n", "<Plug>(core-window-splitter)j", "<cmd>bel split<cr>", {
    desc = "split current window to bottom",
})
vim.keymap.set("n", "<Plug>(core-window-splitter)k", "<cmd>abo split<cr>", {
    desc = "split current window to top",
})
vim.keymap.set("n", "<Plug>(core-window-splitter)l", "<cmd>bel vsplit<cr>", {
    desc = "split current window to right",
})
vim.keymap.set("n", "<Plug>(core-window-splitter)H", "<cmd>abo vnew<cr>", {
    desc = "create a new window to left",
})
vim.keymap.set("n", "<Plug>(core-window-splitter)J", "<cmd>bel new<cr>", {
    desc = "create a new window to bottom",
})
vim.keymap.set("n", "<Plug>(core-window-splitter)K", "<cmd>abo new<cr>", {
    desc = "create a new window to top",
})
vim.keymap.set("n", "<Plug>(core-window-splitter)L", "<cmd>bel vnew<cr>", {
    desc = "create a new window to right",
})

-- Keymaps to manage buffers
vim.keymap.set("n", "<Plug>(core-buffers)h", "<cmd>bprev<cr>", {
    desc = "go to previous buffer",
})
vim.keymap.set("n", "<Plug>(core-buffers)l", "<cmd>bnext<cr>", {
    desc = "go to next buffer",
})
vim.keymap.set("n", "<Plug>(core-buffers)d", "<cmd>bdelete<cr>", {
    desc = "delete current buffer",
})
vim.keymap.set("n", "<Plug>(core-buffers)e", "<cmd>Telescope buffers<cr>", {
    desc = "travel buffers",
})

-- Keymaps to move display line.
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- keymaps for help
vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    group = vim.api.nvim_create_augroup("define-doc-keymaps", {}),
    callback = function()
        local opts = { buffer = 0 }
        vim.keymap.set("n", "<Enter>", "<C-]>", opts)
        vim.keymap.set("n", "u", "<cmd>po<cr>", opts)
        vim.keymap.set("n", "r", "<cmd>ta<cr>", opts)
        vim.keymap.set("n", "U", "<cmd>ta<cr>", opts)
        vim.keymap.set("n", "q", "<cmd>q<cr>", opts)
    end,
})

-- Keymaps to leave from insert mode.
vim.keymap.set("i", "jj", "<ESC>", {
    desc = "leave from insert mode",
})
