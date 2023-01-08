return function()
    local module = require("utils.module")
    local is_ok, mods = pcall(module.require, {
        "notify"
    })
    if not is_ok then
        return
    end

    mods["notify"].setup{
        timeout = 1000,
        fps     = 60,
        stages  = "fade"
    }
    vim.notify = mods["notify"]
end
