return function()
    local module = require("utils.module")
    local is_ok, mods = pcall(module.require, {
        { "indent_blankline", as = "indent" }
    })
    if not is_ok then
        return
    end

    mods["indent"].setup()
end
