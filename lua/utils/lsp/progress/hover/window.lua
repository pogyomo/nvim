---A updatable window which display a mesasge to right.
---@class UpdatableRightWindow
---@field valid boolean
---@field bufid integer
---@field winid integer
---@field message string
---@field row integer
---@field hl_ns integer

---@class UpdatableRightWindow
local M = {}

---@param message string
---@param row integer
---@param opacity integer
---@param fg string?
function M:new(message, row, opacity, fg)
    local hl_ns = vim.api.nvim_create_namespace("")
    local bufid = vim.api.nvim_create_buf(false, true)
    local winid = vim.api.nvim_open_win(bufid, false, {
        relative = "editor",
        row = row,
        col = vim.opt.columns:get() - vim.fn.strdisplaywidth(message),
        width = vim.fn.strdisplaywidth(message),
        height = 1,
        style = "minimal",
    })
    vim.api.nvim_buf_set_lines(bufid, 0, 1, false, { message })
    vim.api.nvim_set_option_value("winblend", opacity, {
        win = winid,
    })
    vim.api.nvim_win_set_hl_ns(winid, hl_ns)
    vim.api.nvim_set_hl(hl_ns, "NormalFloat", {
        fg = fg or "fg",
        bg = "bg",
    })
    return setmetatable({
        valid = true,
        bufid = bufid,
        winid = winid,
        message = message,
        row = row,
        hl_ns = hl_ns,
    }, {
        __index = M,
    })
end

--- Close the window. Closed window is no longer valid and doesn't do anything.
function M:close()
    vim.api.nvim_win_close(self.winid, true)
    pcall(vim.api.nvim_buf_delete, self.bufid, { force = true })
    self.valid = false
end

---@param message? string
---@param row? integer
function M:update(message, row)
    if not self.valid then
        return
    end

    self.message = message or self.message
    self.row = row or self.row

    vim.api.nvim_buf_set_lines(self.bufid, 0, 1, false, { self.message })
    vim.api.nvim_win_set_config(self.winid, {
        relative = "editor",
        row = self.row,
        col = vim.opt.columns:get() - vim.fn.strdisplaywidth(self.message),
        width = vim.fn.strdisplaywidth(self.message),
        height = 1,
    })
end

return M
