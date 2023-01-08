return function()
    local is_ok, indent = pcall(require, "indent_blankline")
    if not is_ok then
        return
    end

    indent.setup()
end
