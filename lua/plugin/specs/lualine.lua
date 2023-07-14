return {
    "nvim-lualine/lualine.nvim",
    config = function()
        local module = require("utils.module")
        local mods   = module.require{
            "lualine",
            "submode"
        }

        local function is_in_range(l, r, value)
            return l <= value and value < r
        end

        local function current_time_clock_emoji()
            local time = os.date("*t")
            if is_in_range(0, 1, time.hour) or is_in_range(12, 13, time.hour) then
                return "󱑖 "
            elseif is_in_range(1, 2, time.hour) or is_in_range(13, 14, time.hour) then
                return "󱑋 "
            elseif is_in_range(2, 3, time.hour) or is_in_range(14, 15, time.hour) then
                return "󱑌 "
            elseif is_in_range(3, 4, time.hour) or is_in_range(15, 16, time.hour) then
                return "󱑍 "
            elseif is_in_range(4, 5, time.hour) or is_in_range(16, 17, time.hour) then
                return "󱑎 "
            elseif is_in_range(5, 6, time.hour) or is_in_range(17, 18, time.hour) then
                return "󱑏 "
            elseif is_in_range(6, 7, time.hour) or is_in_range(18, 19, time.hour) then
                return "󱑐 "
            elseif is_in_range(7, 8, time.hour) or is_in_range(19, 20, time.hour) then
                return "󱑑 "
            elseif is_in_range(8, 9, time.hour) or is_in_range(20, 21, time.hour) then
                return "󱑒 "
            elseif is_in_range(9, 10, time.hour) or is_in_range(21, 22, time.hour) then
                return "󱑓 "
            elseif is_in_range(10, 11, time.hour) or is_in_range(22, 23, time.hour) then
                return "󱑔 "
            elseif is_in_range(11, 12, time.hour) or is_in_range(23, 24, time.hour) then
                return "󱑕 "
            end
        end

        local filename_symbols = {
            modified = "+",
            readonly = "-",
            unnamed  = "no name"
        }
        local fileformat_symbols = {
            unix = " unix",
            dos  = " dos",
            mac  = " mac"
        }

        local status_line = {
            lualine_a = {
                { "mode",  fmt = string.lower },
                function() return mods["submode"]:mode() or "" end
            },
            lualine_b = {
                "branch", "diff", "diagnostics"
            },
            lualine_c = {
                { "filename", symbols = filename_symbols }
            },
            lualine_x = {
                "encoding",
                { "fileformat", symbols = fileformat_symbols },
                "filetype"
            },
            lualine_y = {
                "progress"
            },
            lualine_z = {
                "%l/%L:%c"
            }
        }

        local status_tab = {
            lualine_a = {},
            lualine_b = {
                { "tabs", max_length = vim.o.columns, mode = 2 }
            },
            lualine_c = {},
            lualine_x = {},
            lualine_y = {
                {
                    function()
                        local clock = current_time_clock_emoji()
                        local date  = vim.fn.strftime("%Y/%m/%d %H:%M:%S")
                        return ("%s %s"):format(clock, date)
                    end,
                    color = "lualine_b_normal",
                }
            },
            lualine_z = {}
        }

        local status_bar = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
        }

        mods["lualine"].setup{
            options = {
                theme = "tokyonight",
                globalstatus = true,
                refresh = {
                    statusline = 200,
                    tabline    = 200,
                    winbar     = 200
                }
            },
            sections         = status_line,
            inactive_section = status_line,
            tabline          = status_tab,
            winbar           = status_bar,
            inactive_winbar  = status_bar
        }
    end
}
