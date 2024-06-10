---Check whether the window have neighbor to 'dir' or not.
---@param win integer Window handle, or 0 for current window.
---@param dir "left" | "right" | "up" | "down" Direction to check.
---@return boolean # True if the window have neighbor to 'dir'.
local function have_neighbor_to(win, dir)
    local neighbor = vim.api.nvim_win_call(win, function()
        vim.cmd.wincmd(({
            left = "h",
            right = "l",
            up = "k",
            down = "j",
        })[dir])
        return vim.api.nvim_get_current_win()
    end)
    local n_winnr = vim.api.nvim_win_get_number(neighbor)
    local w_winnr = vim.api.nvim_win_get_number(win)
    return n_winnr ~= w_winnr
end

---Resize the window as normal (not float) window.
---@param win integer Window handle, or 0 for current window.
---@param diff_row integer Diff to be used when resize width.
---@param diff_col integer Diff to be used when resize height.
---@param key_dir "left" | "right" | "up" | "down" Direction to resize.
local function resize_normal(win, diff_row, diff_col, key_dir)
    local dir = (key_dir == "left" or key_dir == "right") and "width"
        or "height"
    local setter = vim.api["nvim_win_set_" .. dir]
    local getter = vim.api["nvim_win_get_" .. dir]

    if key_dir == "left" or key_dir == "right" then
        if have_neighbor_to(win, "right") then
            setter(
                win,
                getter(win) + (key_dir == "right" and diff_col or -diff_col)
            )
        else
            setter(
                win,
                getter(win) + (key_dir == "right" and -diff_col or diff_col)
            )
        end
    else
        if
            not have_neighbor_to(win, "down")
            and not have_neighbor_to(win, "up")
        then
            return
        end

        if have_neighbor_to(win, "down") then
            setter(
                win,
                getter(win) + (key_dir == "down" and diff_row or -diff_row)
            )
        else
            setter(
                win,
                getter(win) + (key_dir == "down" and -diff_row or diff_row)
            )
        end
    end
end

---Resize the window as floating window.
---@param win integer Window handle, or 0 for current window.
---@param diff_row integer Diff to be used when resize width.
---@param diff_col integer Diff to be used when resize height.
---@param key_dir "left" | "right" | "up" | "down" Direction to resize.
local function resize_float(win, diff_row, diff_col, key_dir)
    local dir = (key_dir == "left" or key_dir == "right") and "width"
        or "height"
    local setter = vim.api["nvim_win_set_" .. dir]
    local getter = vim.api["nvim_win_get_" .. dir]

    if key_dir == "left" or key_dir == "right" then
        setter(
            win,
            getter(win) + (key_dir == "right" and diff_col or -diff_col)
        )
    else
        setter(win, getter(win) + (key_dir == "down" and diff_row or -diff_row))
    end
end

---Resize the window.
---@param win integer Window handle, or 0 for current window.
---@param diff_row integer Diff to be used when resize width.
---@param diff_col integer Diff to be used when resize height.
---@param key_dir "left" | "right" | "up" | "down" Direction to resize.
local function resize(win, diff_row, diff_col, key_dir)
    if vim.api.nvim_win_get_config(win).relative ~= "" then
        resize_float(win, diff_row, diff_col, key_dir)
        return
    end

    resize_normal(win, diff_row, diff_col, key_dir)
end

return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup()
            require("cmp").event:on(
                "confirm_done",
                require("nvim-autopairs.completion.cmp").on_confirm_done()
            )
        end,
    },
    {
        "folke/flash.nvim",
        opts = {
            modes = {
                search = {
                    enabled = true,
                },
            },
        },
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        opts = {},
    },
    {
        "pogyomo/submode.nvim",
        dev = true,
        config = function()
            local submode = require("submode")

            submode.setup()

            vim.keymap.set("n", "<Leader>r", "<Plug>(submode-win-resizer)")
            submode.create("WinResizer", {
                mode = "n",
                enter = "<Plug>(submode-win-resizer)",
                leave = { "q", "<ESC>" },
            }, {
                lhs = "h",
                rhs = function()
                    resize(0, 2, 2, "left")
                end,
            }, {
                lhs = "j",
                rhs = function()
                    resize(0, 2, 2, "down")
                end,
            }, {
                lhs = "k",
                rhs = function()
                    resize(0, 2, 2, "up")
                end,
            }, {
                lhs = "l",
                rhs = function()
                    resize(0, 2, 2, "right")
                end,
            })

            submode.create("DocReader", {
                mode = "n",
            }, {
                lhs = "<Enter>",
                rhs = "<C-]>",
            }, {
                lhs = "u",
                rhs = "<cmd>po<cr>",
            }, {
                lhs = { "r", "U" },
                rhs = "<cmd>ta<cr>",
            }, {
                lhs = "q",
                rhs = "<cmd>q<cr>",
            })
            vim.api.nvim_create_augroup("DocReaderAugroup", {})
            vim.api.nvim_create_autocmd("BufEnter", {
                group = "DocReaderAugroup",
                callback = function()
                    if vim.opt.ft:get() == "help" and not vim.bo.modifiable then
                        submode.enter("DocReader")
                    end
                end,
            })
            vim.api.nvim_create_autocmd({ "BufLeave", "CmdwinEnter" }, {
                group = "DocReaderAugroup",
                callback = function()
                    if submode.mode() == "DocReader" then
                        submode.leave()
                    end
                end,
            })
        end,
    },
}
