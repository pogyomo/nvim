local pb   = require("utils.path.builder")
local uv   = vim.loop
local url  = "https://github.com/wbthomason/packer.nvim"
local path = pb.build(vim.fn.stdpath("data"), {
    "site",
    "pack",
    "packer",
    "start",
    "packer.nvim"
})

local M = {}

---Install packer synchronously.
---@return boolean # False if packer already installed.
function M.install_packer()
    if not uv.fs_stat(path) then
        vim.notify("Installing packer...")
        vim.fn.system({
            "git",
            "clone",
            "--depth=1",
            url,
            path
        })
        assert(
            vim.v.shell_error == 0,
            ("Failed to install packer: code is %d"):format(vim.v.shell_error)
        )
        vim.notify("Packer was installed successfully.")
        return true
    else
        return false
    end
end

return M
