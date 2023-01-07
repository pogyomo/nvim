local uv   = vim.loop
local wrap = vim.schedule_wrap
local url  = "https://github.com/wbthomason/packer.nvim"
local path = ("%s/site/pack/packer/start/packer.nvim"):format(vim.fn.stdpath("data"))

return function(callback)
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
                vim.notify("Packer was installed successfully")
            end))
        else
            callback()
        end
    end))
end
