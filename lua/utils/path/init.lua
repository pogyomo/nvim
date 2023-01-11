local M = {}

---Build a path.
---@param base string Base of the path.
---@param rest string[] Rest of path components.
function M.build(base, rest)
    local ret = base
    for _, value in ipairs(rest) do
        ret = ("%s/%s"):format(ret, value)
    end
    return ret
end

return M
