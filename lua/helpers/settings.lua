local M = {}

--- Load user provided settings.json, returns its content.
---
--- @return table
function M.load()
    local path = vim.fs.joinpath(vim.fn.stdpath("config"), "settings.json")
    local fp = io.open(path)
    local settings = {}
    if fp then
        settings = vim.json.decode(fp:read("*a"))
    end
    return settings
end

--- Returns global settings
---
--- @param settings table Settings loaded by load()
---
--- @return table
function M.global_settings(settings)
    local res = {
        fmt = {
            privider = nil,
            ensure_installed = true,
            format_on_save = true,
            use_lsp_format = false,
        },
        lsp = {
            privider = nil,
            ensure_installed = true,
            settings = {},
        },
    }
    for key, value in pairs(settings) do
        local ft = string.match(key, "^%[(%g+)%]$")
        if ft == nil then
            res[key] = vim.tbl_deep_extend("force", res[key], value)
        end
    end
    return res
end

--- Returns settings for all filetype from loaded settings.
---
--- @param settings table Settings loaded by load()
---
--- @return table
function M.ft_settings(settings)
    local global_settings = M.global_settings(settings)
    local res = {}
    for key, value in pairs(settings) do
        local ft = string.match(key, "^%[(%g+)%]$")
        if ft ~= nil then
            res[ft] = vim.tbl_deep_extend("force", global_settings, value)
        end
    end
    return res
end

return M
