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

local function formatter_provider_with_default(setting)
    return vim.tbl_deep_extend("force", {
        ensure_installed = true,
        config = {},
    }, setting)
end

local function with_default(settings)
    local default_settings = {
        ["indent"] = {
            style = "space",
            size = 4,
        },
        ["tree-sitter.uses"] = {},
        ["tree-sitter.indent"] = {
            ["enabled"] = true,
            ["exclude"] = {},
        },
        ["formatter.providers"] = {},
        ["formatter.format_on_save"] = true,
        ["formatter.use_lsp_format"] = false,
        ["formatter.uses"] = {},
        ["lsp.providers"] = {},
        ["lsp.uses"] = {},
    }
    settings = vim.tbl_deep_extend("force", default_settings, settings)
    settings["formatter.providers"] = vim.iter(settings["formatter.providers"])
        :map(function(name, provider)
            return { name, formatter_provider_with_default(provider) }
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
            return {
                fts,
                vim.tbl_deep_extend("force", M.global_settings, settings),
            }
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
