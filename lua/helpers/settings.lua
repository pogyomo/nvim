local M = {
    settings = nil,
    global_settings = nil,
    ft_settings = nil,
}

--- Returns global settings
---
--- @return table
function M.get_global_settings()
    if M.global_settings then
        return M.global_settings
    end
    M.__load()

    M.global_settings = {
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
            config = {},
        },
    }
    for key, value in pairs(M.settings) do
        local fts = M.__extract_fts(key)
        if fts == nil then
            M.global_settings[key] =
                vim.tbl_deep_extend("force", M.global_settings[key], value)
        end
    end
    return M.global_settings
end

--- Returns settings for all filetype from loaded settings.
---
--- @return table
function M.get_ft_settings()
    if M.ft_settings ~= nil then
        return M.ft_settings
    end
    M.__load()

    local global_settings = M.get_global_settings()
    local res = {}
    for key, value in pairs(M.settings) do
        local fts = M.__extract_fts(key)
        if fts ~= nil then
            res[fts] = vim.tbl_deep_extend("force", global_settings, value)
        end
    end
    return res
end

--- Load user provided settings.json.
function M.__load()
    if M.settings ~= nil then
        return
    end

    local path = vim.fs.joinpath(vim.fn.stdpath("config"), "settings.json")
    local fp = io.open(path)
    local settings = {}
    if fp then
        local success, e = pcall(function()
            settings = vim.json.decode(fp:read("*a"))
        end)
        if not success then
            vim.notify(e, vim.log.levels.ERROR)
            settings = {}
        end
    end
    M.settings = settings
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
