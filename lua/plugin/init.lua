local path      = require("utils.path")
local uv        = vim.loop
local lazy_url  = "https://github.com/folke/lazy.nvim"
local lazy_path = path.build(vim.fn.stdpath("data"), {
    "lazy",
    "lazy.nvim"
})

-- Install lazy if not exist
if not uv.fs_stat(lazy_path) then
    vim.notify("Installing lazy...")
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        lazy_url,
        "--branch=stable",
        lazy_path
    })
    assert(
        vim.v.shell_error == 0,
        ("Failed to install lazy: code is %d"):format(vim.v.shell_error)
    )
    vim.notify("Lazy was installed successfully.")
    vim.opt.rtp:prepend(lazy_path)
else
    vim.opt.rtp:prepend(lazy_path)
end

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
    }
})
