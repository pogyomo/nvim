local M = {
    group = vim.api.nvim_create_augroup("pogyomo.event", {}),
    pattern_prefix = "pogyomo.event.",
}

--- Emit event.
---
--- @param event string
function M.emit(event)
    vim.api.nvim_exec_autocmds("User", {
        pattern = M.pattern_prefix .. event,
    })
end

--- Call callback once when event emitted.
---
--- @param event string
--- @param callback function
function M.once(event, callback)
    vim.api.nvim_create_autocmd("User", {
        once = true,
        group = M.group,
        pattern = M.pattern_prefix .. event,
        callback = callback,
    })
end

return M
