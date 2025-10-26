local M = {
    global_settings = nil,
    ft_settings = nil,
}

local function lsp_provider_with_default(setting)
    return vim.tbl_deep_extend("force", {
        ensure_installed = true,
        config = {},
    }, setting)
end

local function fmt_provider_with_default(setting)
    return vim.tbl_deep_extend("force", {
        ensure_installed = true,
    }, setting)
end

local function with_default(settings)
    local default_settings = {
        ["indent"] = {
            style = "space",
            size = 4,
        },
        ["fmt.providers"] = {},
        ["fmt.format_on_save"] = true,
        ["fmt.use_lsp_format"] = false,
        ["fmt.uses"] = {},
        ["lsp.providers"] = {},
        ["lsp.uses"] = {},
    }
    settings = vim.tbl_deep_extend("force", default_settings, settings)
    settings["fmt.providers"] = vim.iter(settings["fmt.providers"])
        :map(function(name, provider)
            return { name, fmt_provider_with_default(provider) }
        end)
        :fold({}, function(acc, value)
            acc[value[1]] = value[2]
            return acc
        end)
    settings["lsp.providers"] = vim.iter(settings["lsp.providers"])
        :map(function(name, provider)
            return { name, lsp_provider_with_default(provider) }
        end)
        :fold({}, function(acc, value)
            acc[value[1]] = value[2]
            return acc
        end)
    return settings
end

--- Returns global settings
---
--- @return table
function M.get_global_settings()
    M.__load()
    return M.global_settings
end

--- Returns settings for all filetype from loaded settings.
---
--- @return table
function M.get_ft_settings()
    M.__load()
    return M.ft_settings
end

--- Load user provided settings.json.
function M.__load()
    if M.global_settings ~= nil and M.ft_settings ~= nil then
        return
    end

    local path = vim.fs.joinpath(vim.fn.stdpath("config"), "settings.json")
    local fp = io.open(path)
    local user_settings = {}
    if fp then
        local success, e = pcall(function()
            user_settings = vim.json.decode(fp:read("*a"))
        end)
        if not success then
            vim.notify(e, vim.log.levels.ERROR)
            user_settings = {}
        end
    end

    M.global_settings = {}
    M.ft_settings = {}
    for key, value in pairs(user_settings) do
        local fts = M.__extract_fts(key)
        if fts == nil then
            M.global_settings[key] = value
        else
            M.ft_settings[fts] = value
        end
    end

    M.global_settings = with_default(M.global_settings)
    M.ft_settings = vim.iter(M.ft_settings)
        :map(function(fts, settings)
            return { fts, with_default(settings) }
        end)
        :fold({}, function(acc, value)
            acc[value[1]] = value[2]
            return acc
        end)
end

--- Get filetypes from "[...]".
---
--- @param key string
---
--- @return table | nil # nil if key is not "[...]".
function M.__extract_fts(key)
    local inner = string.match(key, "^%[(.*)%]$")
    if inner == nil then
        return nil
    end

    local fts = {}
    for ft in string.gmatch(inner, "([^,]+)") do
        fts[#fts + 1] = ft:match("^%s*(.-)%s*$")
    end
    return fts
end

return M
