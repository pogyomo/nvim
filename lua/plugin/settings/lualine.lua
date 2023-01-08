return function()
    local module = require("utils.module")
    local is_ok, mods = pcall(module.require, {
        "lualine"
    })
    if not is_ok then
        return
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
            { "mode",  fmt = string.lower }
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
            "vim.fn.strftime(' %Y/%m/%d %H:%M:%S')"
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
            theme = "sonokai",
            globalstatus = true,
            refresh = {
                statusline = 100,
                tabline    = 100,
                winbar     = 100
            }
        },
        sections         = status_line,
        inactive_section = status_line,
        tabline          = status_tab,
        winbar           = status_bar,
        inactive_winbar  = status_bar
    }
end
