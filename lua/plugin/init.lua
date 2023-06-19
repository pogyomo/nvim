local path      = require("utils.path")
local uv        = vim.loop
local lazy_url  = "https://github.com/folke/lazy.nvim"
local lazy_path = path.build(vim.fn.stdpath("data"), {
    "lazy",
    "lazy.nvim"
})

-- Install lazy if not exist
if not uv.fs_stat(lazy_path) then
    vim.system({
        "git",
        "clone",
        "--filter=blob:none",
        lazy_url,
        "--branch=stable",
        lazy_path
    }):wait()
end
vim.opt.rtp:prepend(lazy_path)

-- Register autocmd to set transparency to lazy's menu.
vim.api.nvim_create_augroup("__lazy_menu", {})
vim.api.nvim_create_autocmd("FileType", {
    group = "__lazy_menu",
    pattern = "lazy",
    callback = function()
        vim.opt.winblend = 10
    end
})

require("lazy").setup("plugin.specs", {
    ui = {
        border = "rounded"
    },
    install = {
        colorscheme = { "sonokai" }
    },
    change_detection = {
        notify = false
    },
    dev = {
        path = os.getenv("LAZY_DEV_PATH") or "~/projects",
        fallback = true,
    }
})
