local winmgr = require("utils.lsp.progress.hover.winmgr")
local spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

---@class ProgressHover
---@field client_to_winmanager ClientToWinManager
local M = {
    client_to_winmanager = {}
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
---@param token ProgressToken
---@param value ProgressValue
function M.update_by_client_id(client_id, token, value)
    if M.client_to_winmanager[client_id] == nil then
        local client = vim.lsp.get_client_by_id(client_id)
        local title = client and client.name or "unknown"
        local row_base = function()
            return vim.o.lines - 3
        end
        M.client_to_winmanager[client_id] = winmgr:new(title, row_base, spinner, "✓", 1000, 100)
    end
    local manager = M.client_to_winmanager[client_id]

    local message = string.format("[%s] %s", value.title, value.message or "completed")
    manager:update(message, token, value.kind == "end")
end

return M
