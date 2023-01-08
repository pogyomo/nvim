return function()
    local module = require("utils.module")
    local is_ok, mods = pcall(module.require, {
        "cmp",
        { "nvim-autopairs", as = "autopairs" },
        { "nvim-autopairs.completion.cmp", as = "autopairs_cmp" }
    })
    if not is_ok then
        return
    end

    mods["autopairs"].setup()
    mods["cmp"].event:on(
        "confirm_done",
        mods["autopairs_cmp"].on_confirm_done()
    )
end
