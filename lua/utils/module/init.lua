---@alias Module string | { [1]: string, as: string }

---Parse module.
---@param mod Module Module to parse.
---@return string # Actual name of the module.
---@return string # Alias of the module.
local function parse_mod(mod)
    vim.validate {
        mod = { mod, { "string", "table" } },
    }

    if type(mod) == "string" then
        return mod, mod
    else
        return mod[1], mod.as
    end
end

local M = {}

---Require multiple modules.
---@param mods Module[]
---@return any
function M.require(mods)
    vim.validate {
        mods = { mods, "table" },
    }

    local ret = {}
    for _, mod in ipairs(mods) do
        local name, alias = parse_mod(mod)
        ret[alias] = require(name)
    end
    return ret
end

return M
