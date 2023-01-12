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

require("lazy").setup("plugin.specs")
