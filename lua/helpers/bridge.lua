local M = {
    -- mason.nvim to conform mapping
    conform_mapping = {
        ["clang-format"] = "clang-format",
        ["prettier"] = "prettier",
        ["rustfmt"] = "rustfmt",
        ["stylua"] = "stylua",
        ["gofmt"] = "gofmt",
    },
}

--- Get conform.nvim style formatter name from mason.nvim uses name
---
--- @param mason_name string mason.nvim uses name
--- @return string # conform.nvim uses name
function M.get_conform_name(mason_name)
    if M.conform_mapping[mason_name] == nil then
        return mason_name
    end
    return M.conform_mapping[mason_name]
end

return M
