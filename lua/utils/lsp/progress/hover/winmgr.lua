---@class WindowManager
---@field title UpdatableRightWindow
---@field title_msg string
---@field messages TokenWindow[]
---@field row_base integer
---@field spinner string[]
---@field spinner_idx integer
---@field fin_icon string
---@field timeout integer
---@field on_exit function

---@class TokenWindow
---@field token ProgressToken
---@field window UpdatableRightWindow

local window = require("utils.lsp.progress.hover.window")

---@class WindowManager
local M = {}

---@param title string
---@param row_base fun(): integer
---@param spinner string[]
---@param fin_icon string
---@param timeout integer
---@param on_exit function
function M:new(title, row_base, spinner, fin_icon, timeout, on_exit)
    assert(#spinner ~= 0, "empty spinner is not allowd")
    local mgr = setmetatable({
        title = window:new(title, 1, 30, "LightMagenta"),
        title_msg = title,
        messages = {},
        row_base = row_base,
        spinner = spinner,
        spinner_idx = 1,
        fin_icon = fin_icon,
        timeout = timeout,
        on_exit = on_exit,
    }, {
        __index = M,
    })
    mgr:__update_windows_row()
    return mgr
end

---Append a new progress message.
---@param message string
---@param token ProgressToken
function M:append(message, token)
    table.insert(self.messages, 1, {
        token = token,
        window = window:new(message, 1, 30)
    })
    self:__update_windows_row()
end

---Update already exist progress message associated with given token.
---@param message string
---@param token ProgressToken
---@param remove boolean If true, remove this progress message.
function M:update(message, token, remove)
    for _, tkwin in ipairs(self.messages) do
        if tkwin.token == token then
            tkwin.window:update(message)
            if remove then
                vim.defer_fn(function()
                    self:__remove_message(token)
                end, self.timeout)
            end
        end
    end
    self:__update_windows_row()
end

---@package
---@param row? integer
function M:__update_title(row)
    self.title:update(self:__advance_spinner() .. " " .. self.title_msg, row)
end

---@package
function M:__update_windows_row()
    local diff = 0
    for _, tkwin in ipairs(self.messages) do
        tkwin.window:update(nil, self.row_base() + diff)
        diff = diff - 1
    end
    self:__update_title(self.row_base() + diff)
end

---@package
---@param token ProgressToken
function M:__remove_message(token)
    for pos, tkwin in ipairs(self.messages) do
        if tkwin.token == token then
            tkwin.window:close()
            table.remove(self.messages, pos)
            self:__update_windows_row()
            break
        end
    end

    if #self.messages == 0 then
        self.title:update(self.fin_icon .. " " .. self.title_msg, nil)
        vim.defer_fn(function()
            self.title:close()
            self.on_exit()
        end, self.timeout)
    end
end

---@package
---@return string
function M:__advance_spinner()
    assert(#self.spinner ~= 0)
    local icon = self.spinner[self.spinner_idx]
    self.spinner_idx = self.spinner_idx + 1
    if self.spinner_idx > #self.spinner then
        self.spinner_idx = 1
    end
    return icon
end

return M
