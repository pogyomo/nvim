---@class WindowManager
---@field title TitleWindow
---@field messages TokenWindow[]
---@field row_base integer
---@field spinner string[]
---@field spinner_idx integer
---@field fin_icon string
---@field timeout integer
---@field refresh_rate integer
---@field timer uv_timer_t

---@class StatefulWindow
---@field state WindowState
---@field window UpdatableRightWindow
---@field timer integer

---@class TitleWindow
---@field title string
---@field window StatefulWindow

---@class TokenWindow
---@field token ProgressToken
---@field window StatefulWindow state must be either `showing` or `closing`.

---@enum WindowState
local WINDOWSTATE = {
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
---@param refresh_rate integer
function M:new(title, row_base, spinner, fin_icon, timeout, refresh_rate)
    assert(#spinner ~= 0, "empty spinner is not allowd")
    local mgr = setmetatable({
        title = {
            title = title,
            window = {
                state = WINDOWSTATE.closed,
                window = nil,
                timer = timeout,
            },
        },
        messages = {},
        row_base = row_base,
        spinner = spinner,
        spinner_idx = 1,
        fin_icon = fin_icon,
        timeout = timeout,
        refresh_rate = refresh_rate,
        timer = vim.uv.new_timer(),
    }, {
        __index = M,
    })
    mgr.timer:start(0, mgr.refresh_rate, vim.schedule_wrap(function()
        for _, tkwin in ipairs(mgr.messages) do
            if tkwin.window.state == WINDOWSTATE.closing then
                if tkwin.window.timer > 0 then
                    tkwin.window.timer = tkwin.window.timer - mgr.refresh_rate
                else
                    mgr:__remove_message(tkwin.token)
                end
            end
        end

        if mgr.title.window.state == WINDOWSTATE.showing then
            if #mgr.messages == 0 then
                mgr.title.window.state = WINDOWSTATE.closing
                mgr.title.window.timer = mgr.timeout
            end
        elseif mgr.title.window.state == WINDOWSTATE.closing then
            if #mgr.messages == 0 then
                if mgr.title.window.timer > 0 then
                    mgr.title.window.timer = mgr.title.window.timer - mgr.refresh_rate
                else
                    mgr.title.window.window:close()
                    mgr.title.window.window = nil
                    mgr.title.window.state = WINDOWSTATE.closed
                end
            else
                mgr.title.window.state = WINDOWSTATE.showing
            end
        elseif mgr.title.window.state == WINDOWSTATE.closed then
            if #mgr.messages ~= 0 then
                mgr.title.window.window = window:new(mgr.title_msg, 1, 30, "LightMagenta")
                mgr.title.window.state = WINDOWSTATE.showing
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
            assert(tkwin.window.state ~= WINDOWSTATE.closed)
            tkwin.window.window:update(message)
            if tkwin.window.state == WINDOWSTATE.showing then
                if remove then
                    tkwin.window.state = WINDOWSTATE.closing
                    tkwin.window.timer = self.timeout
                end
            elseif tkwin.window.state == WINDOWSTATE.closing then
                if not remove then
                    tkwin.window.state = WINDOWSTATE.showing
                    tkwin.window.timer = self.timeout
                end
            end
            return
        end
    end
    table.insert(self.messages, 1, {
        token = token,
        window = {
            state = WINDOWSTATE.showing,
            window = window:new(message, 1, 30),
            timer = self.timeout
        }
    })
end

---@package
function M:__update_windows_row()
    local row = self.row_base()
    for _, tkwin in ipairs(self.messages) do
        assert(tkwin.window.state ~= WINDOWSTATE.closed)
        tkwin.window.window:update(nil, row)
        row = row - 1
    end
    self:__update_title(row)
end

---@package
---@param row? integer
function M:__update_title(row)
    if self.title.window.state == WINDOWSTATE.showing then
        self.title.window.window:update(self:__advance_spinner() .. " " .. self.title.title, row)
    elseif self.title.window.state == WINDOWSTATE.closing then
        self.title.window.window:update(self.fin_icon .. " " .. self.title.title, row)
    end
end

---@package
---@param token ProgressToken
function M:__remove_message(token)
    for pos, tkwin in ipairs(self.messages) do
        if tkwin.token == token then
            assert(tkwin.window.state ~= WINDOWSTATE.closed)
            tkwin.window.window:close()
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
