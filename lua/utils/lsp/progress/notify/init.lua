
---@alias CliendId integer
---@alias ProgressToken integer | string
---@alias Notifies table<ProgressToken, NotifyInfomation>

---@class NotifyInfomation
---@field record notify.Record
---@field spinner fun(): string

---@class LspProgressNotify
---@field client_to_notifies table<CliendId, Notifies>
local M = {}

function M.setup()
    ---Create a iterator which when called, return next spinner.
    ---@return fun(): string
    local function spinner()
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

    M.client_to_notifies = {}
    vim.api.nvim_create_autocmd("LspProgress", {
        group = vim.api.nvim_create_augroup("__lsp_progress_notify", {}),
        callback = function(event)
            local client_id = event.data.client_id
            local value = event.data.result.value
            local token = event.data.result.token

            M.client_to_notifies[client_id] = M.client_to_notifies[client_id] or {}

            local title = vim.lsp.get_client_by_id(client_id).name
            local message = string.format("[%s] %s", value.title, value.message or "completed")

            local notifies = M.client_to_notifies[client_id]
            if value.kind == "begin" then
                notifies[token] = {}
                notifies[token].spinner = spinner()
                notifies[token].record = vim.notify(message, vim.log.levels.INFO, {
                    title = title,
                    icon = notifies[token].spinner(),
                    timeout = false,
                    render = "compact",
                }) --[[@as notify.Record]]
            elseif value.kind == "report" then
                notifies[token].record = vim.notify(message, vim.log.levels.INFO, {
                    icon = notifies[token].spinner(),
                    replace = notifies[token].record,
                }) --[[@as notify.Record]]
            elseif value.kind == "end" then
                vim.notify(message, vim.log.levels.INFO, {
                    icon = "",
                    replace = notifies[token].record,
                    timeout = 1000,
                })
                notifies[token] = nil
            end
        end,
    })
end

return M
