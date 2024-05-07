---Move floating window.
---@param win integer Window handle, or 0 for current window.
---@param diff_row integer Diff to be used when move the window horizontally.
---@param diff_col integer Diff to be used when move the window vertically.
---@param key_dir "left" | "right" | "up" | "down" Direction to move.
return function(win, diff_row, diff_col, key_dir)
    if vim.api.nvim_win_get_config(win).relative == "" then
        return
    end

    local dir = (key_dir == "left" or key_dir == "right") and "col" or "row"
    local setter = function(val)
        local config =
            vim.tbl_extend("force", vim.api.nvim_win_get_config(win), {
                [dir] = val,
            })
        vim.api.nvim_win_set_config(win, config)
    end
    local getter = function()
        return vim.api.nvim_win_get_config(win)[dir][false]
    end

    if key_dir == "left" or key_dir == "right" then
        setter(getter() + (key_dir == "right" and diff_col or -diff_col))
    else
        setter(getter() + (key_dir == "down" and diff_row or -diff_row))
    end
end
