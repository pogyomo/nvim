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
        indent = {
            style = "space",
            size = 4,
        },
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
        local fts = M.__extract_fts(key)
        if fts == nil then
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
        local fts = M.__extract_fts(key)
        if fts ~= nil then
            for _, ft in ipairs(fts) do
                res[ft] = vim.tbl_deep_extend("force", global_settings, value)
            end
        end
    end
    return res
end

--- Get filetypes from "[...]".
---
--- @param key string
---
--- @return table | nil # nil if key is not "[...]".
function M.__extract_fts(key)
    local inner = string.match(key, "^%[(%g+)%]$")
    if inner == nil then
        return nil
    end

    local fts = {}
    for ft in string.gmatch(inner, "([^,]+)") do
        fts[#fts + 1] = ft
    end
    return fts
end

return M
