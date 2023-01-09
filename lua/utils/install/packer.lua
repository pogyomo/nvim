local pb   = require("utils.path.builder")
local uv   = vim.loop
local wrap = vim.schedule_wrap
local url  = "https://github.com/wbthomason/packer.nvim"
local path = pb.build(vim.fn.stdpath("data"), {
    "site",
    "pack",
    "packer",
    "start",
    "packer.nvim"
})

local M = {}

---Install packer.
---@param callback function Callback which will be called after packer installed.
function M.install(callback)
    callback = callback or function() end
    uv.fs_stat(path, wrap(function(err)
        if err then
            vim.notify("Installing packer...")
            uv.spawn("git", {
                args = {
                    "clone",
                    "--depth=1",
                    url,
                    path
                }
            }, wrap(function(code)
                assert(code == 0, ("Failed to install packer: code %d"):format(code))
                vim.notify("Packer installed successfully.")
                callback()
            end))
        else
            callback()
        end
    end))
end

return M
