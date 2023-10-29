---@class WindowManager
---@field title UpdatableRightWindow
---@field title_msg string
---@field title_state TitleState
---@field title_timer integer
---@field messages TokenWindow[]
---@field row_base integer
---@field spinner string[]
---@field spinner_idx integer
---@field fin_icon string
---@field timeout integer
---@field timer uv_timer_t

---@class TokenWindow
---@field token ProgressToken
---@field window UpdatableRightWindow
---@field removable boolean
---@field timer integer

---@enum TitleState
local TITLESTATE = {
    showing = 0,
    closing = 1,
    closed = 2,
}

local window = require("utils.lsp.progress.hover.window")

---@class WindowManager
local M = {}

---@param title string
---@param row_base fun(): integer
---@param spinner string[]
---@param fin_icon string
---@param timeout integer
function M:new(title, row_base, spinner, fin_icon, timeout)
    assert(#spinner ~= 0, "empty spinner is not allowd")
    local mgr = setmetatable({
        title = nil,
        title_msg = title,
        title_state = TITLESTATE.closed,
        title_timer = 100,
        messages = {},
        row_base = row_base,
        spinner = spinner,
        spinner_idx = 1,
        fin_icon = fin_icon,
        timeout = timeout,
        timer = vim.uv.new_timer(),
    }, {
        __index = M,
    })
    mgr.timer:start(0, 100, vim.schedule_wrap(function()
        for _, tkwin in ipairs(mgr.messages) do
            if tkwin.removable and tkwin.timer > 0 then
                tkwin.timer = tkwin.timer - 100
            elseif tkwin.removable then
                mgr:__remove_message(tkwin.token)
                mgr:__update_windows_row()
            end
        end

        if mgr.title_state == TITLESTATE.showing then
            if #mgr.messages == 0 then
                mgr.title_state = TITLESTATE.closing
                mgr.title_timer = mgr.timeout
            end
        elseif mgr.title_state == TITLESTATE.closing then
            if #mgr.messages == 0 then
                if mgr.title_timer > 0 then
                    mgr.title_timer = mgr.title_timer - 100
                else
                    mgr.title:close()
                    mgr.title = nil
                    mgr.title_state = TITLESTATE.closed
                end
            else
                mgr.title_state = TITLESTATE.showing
            end
        elseif mgr.title_state == TITLESTATE.closed then
            if #mgr.messages ~= 0 then
                mgr.title = window:new(mgr.title_msg, 1, 30, "LightMagenta")
                mgr.title_state = TITLESTATE.showing
            end
        end

        mgr:__update_windows_row()
    end))
    return mgr
end

---Update already exist progress message associated with given token, or create if not exist.
---@param message string
---@param token ProgressToken
---@param remove boolean If true, remove this progress message.
function M:update(message, token, remove)
    for _, tkwin in ipairs(self.messages) do
        if tkwin.token == token then
            tkwin.window:update(message)
            if remove then
                tkwin.removable = true
                tkwin.timer = self.timeout
            end
            return
        end
    end
    self:__append(message, token)
end

---Append a new progress message.
---@param message string
---@param token ProgressToken
function M:__append(message, token)
    table.insert(self.messages, 1, {
        token = token,
        window = window:new(message, 1, 30)
    })
    self:__update_windows_row()
end

---@package
---@param row? integer
---@param fin_icon boolean
function M:__update_title(row, fin_icon)
    if fin_icon then
        self.title:update(self.fin_icon .. " " .. self.title_msg, row)
    else
        self.title:update(self:__advance_spinner() .. " " .. self.title_msg, row)
    end
end

---@package
function M:__update_windows_row()
    local diff = 0
    for _, tkwin in ipairs(self.messages) do
        tkwin.window:update(nil, self.row_base() + diff)
        diff = diff - 1
    end
    if self.title_state == TITLESTATE.showing then
        self:__update_title(self.row_base() + diff, false)
    elseif self.title_state == TITLESTATE.closing then
        self:__update_title(self.row_base() + diff, true)
    end
end

---@package
---@param token ProgressToken
function M:__remove_message(token)
    for pos, tkwin in ipairs(self.messages) do
        if tkwin.token == token then
            tkwin.window:close()
            table.remove(self.messages, pos)
            break
        end
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
