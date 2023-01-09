return function()
    local module = require("utils.module")
    local is_ok, mods = pcall(module.require, {
        "todo-comments"
    })
    if not is_ok then
        return
    end

    vim.o.signcolumn = "yes"
    mods["todo-comments"].setup{
        keywords = {
            REVIEW =  { icon = " ", color = "info" },
            CHANGED = { icon = " ", color = "hint" }
        }
    }
end
