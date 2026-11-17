-- Helpers for working with msys2.
local M = {}

--- Check if in msys2
--- @return boolean
local function is_msys2()
    return vim.o.shell:find("msys64") ~= nil
end

--- Check if using unix shell
--- @return boolean
local function is_unix_shell()
    return vim.o.shell:find("bash") or vim.o.shell:find("zsh")
end

--- Check if in msys2, and 'shell' is unix shell (like bash.exe).
--- @return boolean true if in msys2 and using unix shell
function M.is_msys2_unix_shell()
    return is_msys2() and is_unix_shell()
end

return M
