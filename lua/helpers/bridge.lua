local M = {
    -- conform.nvim to mason.nvim mapping
    conform_to_mason = {},
}

--- Get conform.nvim style formatter name from mason.nvim uses name
---
--- @param conform_name string conform.nvim uses name
--- @return string # mason.nvim uses name
function M.convert_conform_to_mason(conform_name)
    if M.conform_to_mason[conform_name] == nil then
        return conform_name
    end
    return M.conform_to_mason[conform_name]
end

return M
