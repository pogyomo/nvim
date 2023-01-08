return function()
    local module = require("utils.module")
    local is_ok, mods = pcall(module.require, {
        { "nvim-autopairs", as = "autopairs" },
    })
    if not is_ok then
        return
    end

    mods["autopairs"].setup()
end
