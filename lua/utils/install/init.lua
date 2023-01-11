local path = require("utils.path")
local uv   = vim.loop

local M = {}

---Install packer synchronously.
---@return boolean # False if packer already installed.
function M.install_packer()
    local packer_url  = "https://github.com/wbthomason/packer.nvim"
    local packer_path = path.build(vim.fn.stdpath("data"), {
        "site",
        "pack",
        "packer",
        "start",
        "packer.nvim"
    })

    if not uv.fs_stat(packer_path) then
        vim.notify("Installing packer...")
        vim.fn.system({
            "git",
            "clone",
            "--depth=1",
            packer_url,
            packer_path
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
