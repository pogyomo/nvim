---Check whether the window have neighbor to 'dir' or not.
---@param window integer Window handle, or 0 for current window.
---@param dir "left" | "right" | "up" | "down" Direction to check.
---@return boolean # True if the window have neighbor to 'dir'.
local function have_neighbor_to(window, dir)
    local neighbor = vim.api.nvim_win_call(window, function()
        vim.cmd.wincmd(({
            left  = "h",
            right = "l",
            up    = "k",
            down  = "j"
        })[dir])
        return vim.api.nvim_get_current_win()
    end)
    local n_winnr = vim.api.nvim_win_get_number(neighbor)
    local w_winnr = vim.api.nvim_win_get_number(window)
    return n_winnr == w_winnr
end

---Resize the window as normal (not float) window.
---@param win integer Window handle, or 0 for current window.
---@param diff_row integer Diff to be used when resize width.
---@param diff_col integer Diff to be used when resize height.
---@param key_dir "left" | "right" | "up" | "down" Direction to resize.
local function resize_normal(win, diff_row, diff_col, key_dir)
    local dir = (key_dir == "left" or key_dir == "right") and "width" or "height"
    local setter = vim.api["nvim_win_set_" .. dir]
    local getter = vim.api["nvim_win_get_" .. dir]

    if key_dir == "left" or key_dir == "right" then
        if have_neighbor_to(win, "right") then
            setter(win, getter(win) + (key_dir == "left" and diff_col or -diff_col))
        else
            setter(win, getter(win) + (key_dir == "left" and -diff_col or diff_col))
        end
    else
        if have_neighbor_to(win, "down") then
            setter(win, getter(win) + (key_dir == "up" and diff_row or -diff_row))
        else
            setter(win, getter(win) + (key_dir == "up" and -diff_row or diff_row))
        end
    end
end

---Resize the window as floating window.
---@param win integer Window handle, or 0 for current window.
---@param diff_row integer Diff to be used when resize width.
---@param diff_col integer Diff to be used when resize height.
---@param key_dir "left" | "right" | "up" | "down" Direction to resize.
local function resize_float(win, diff_row, diff_col, key_dir)
    local dir = (key_dir == "left" or key_dir == "right") and "width" or "height"
    local setter = vim.api["nvim_win_set_" .. dir]
    local getter = vim.api["nvim_win_get_" .. dir]

    if key_dir == "left" or key_dir == "right" then
        setter(win, getter(win) + (key_dir == "right" and diff_col or -diff_col))
    else
        setter(win, getter(win) + (key_dir == "down" and diff_row or -diff_row))
    end
end

---Resize the window.
---@param win integer Window handle, or 0 for current window.
---@param diff_row integer Diff to be used when resize width.
---@param diff_col integer Diff to be used when resize height.
---@param key_dir "left" | "right" | "up" | "down" Direction to resize.
return function(win, diff_row, diff_col, key_dir)
    if vim.api.nvim_win_get_config(win).relative ~= "" then
        resize_float(win, diff_row, diff_col, key_dir)
        return
    end

    if vim.fn.winlayout()[1] == "leaf" then
        return
    end

    resize_normal(win, diff_row, diff_col, key_dir)
end
