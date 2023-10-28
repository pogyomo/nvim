---@alias ClientId integer
---@alias ProgressToken integer | string
---@class ProgressValue
---@field kind "begin" | "report" | "end"
---@field title string
---@field message string
---@alias ClientToWinManager table<ClientId, WindowManager>
