---@alias ClientId integer
---@alias ProgressToken integer | string
---@class ProgressValue
---@field kind "begin" | "report" | "end"
---@field title string
---@field message string
---@alias ClientToWindows table<ClientId, TokenWindow[]>
---@class TokenWindow
---@field token ProgressToken? progress token, or nil when title
---@field window UpdatableRightWindow

local window = require("utils.lsp.progress.hover.window")

local function gen_spinner()
    local idx = 1
    local tbl = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
    return function()
        idx = idx + 1
        if idx == #tbl + 1 then
            idx = 1
        end
        return tbl[idx]
    end
end

local spinner = gen_spinner()

---@class ProgressHover
---@field client_to_windows ClientToWindows
local M = {
    client_to_windows = {}
}

function M.setup()
    vim.api.nvim_create_autocmd("LspProgress", {
        group = vim.api.nvim_create_augroup("__lsp_progress_hover", {}),
        callback = function(event)
            local client_id = event.data.client_id
            local value = event.data.result.value
            local token = event.data.result.token
            M.update_by_client_id(client_id, token, value)
        end,
    })
end

---@param client_id ClientId
function M.update_window_pos_by_client_id(client_id)
    local windows = M.client_to_windows[client_id]

    if #windows == 1 then
        local client = vim.lsp.get_client_by_id(client_id)
        local title = client and client.name or "unknown"
        vim.defer_fn(function()
            windows[1].window:close()
            table.remove(windows)
        end, 1000)
        local pos = vim.opt.lines:get() - 3
        windows[1].window:update("✓ " .. title, pos)
    else
        local pos = vim.opt.lines:get() - 3
        for _, tkwin in ipairs(windows) do
            tkwin.window:update(nil, pos)
            pos = pos - 1;
        end
    end
end

---@param client_id ClientId
---@param token ProgressToken
---@param value ProgressValue
function M.update_by_client_id(client_id, token, value)
    M.client_to_windows[client_id] = M.client_to_windows[client_id] or {}
    local windows = M.client_to_windows[client_id]
    local message = ("[%s] %s"):format(value.title, value.message or "completed")

    local client = vim.lsp.get_client_by_id(client_id)
    local title = client and client.name or "unknown"
    if #windows == 0 then
        table.insert(windows, 1, {
            window = window:new(spinner() .. " " .. title, 0, 30),
            token = nil,
        })
    else
        windows[#windows].window:update(spinner() .. " " .. title)
    end

    if value.kind == "begin" then
        table.insert(windows, 1, {
            window = window:new(message, 0, 30),
            token = token,
        })
    elseif value.kind == "report" then
        for _, tkwin in ipairs(windows) do
            if tkwin.token == token then
                tkwin.window:update(message)
            end
        end
    else
        for _, tkwin in ipairs(windows) do
            if tkwin.token == token then
                tkwin.window:update(message)
                vim.defer_fn(function()
                    for pos, _tkwin in ipairs(windows) do
                        if _tkwin.token == token then
                            table.remove(windows, pos)
                            _tkwin.window:close()
                            M.update_window_pos_by_client_id(client_id)
                        end
                    end
                end, 1000)
                break
            end
        end
    end

    M.update_window_pos_by_client_id(client_id)
end

return M
