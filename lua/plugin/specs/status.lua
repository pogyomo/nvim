return {
    {
        "luukvbaal/statuscol.nvim",
        dependencies = {
            "lewis6991/gitsigns.nvim",
        },
        config = function()
            local builtin = require("statuscol.builtin")

            require("statuscol").setup {
                segments = {
                    {
                        sign = {
                            namespace = { "diagnostic/signs" },
                        },
                    },
                    {
                        sign = {
                            namespace = { "gitsigns" },
                            colwidth = 1,
                        },
                    },
                    { text = { builtin.lnumfunc } },
                    { text = { " " } },
                },
            }
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local filename_symbols = {
                modified = "+",
                readonly = "-",
                unnamed = "no name",
            }

            local fileformat_symbols = {
                unix = " unix",
                dos = " dos",
                mac = " mac",
            }

            local status_line = {
                lualine_a = {
                    { "mode", fmt = string.lower },
                    function()
                        return require("submode").mode() or ""
                    end,
                },
                lualine_b = {
                    "branch",
                    "diff",
                    "diagnostics",
                },
                lualine_c = {
                    { "filename", symbols = filename_symbols },
                },
                lualine_x = {
                    "encoding",
                    { "fileformat", symbols = fileformat_symbols },
                    "filetype",
                },
                lualine_y = {
                    "progress",
                },
                lualine_z = {
                    "%l/%L:%c",
                },
            }

            local status_tab = {
                lualine_a = {},
                lualine_b = {
                    { "buffers", max_length = vim.o.columns, mode = 2 },
                },
                lualine_c = {},
                lualine_x = {},
                lualine_y = {
                    { "tabs", max_length = vim.o.columns, mode = 0 },
                    {
                        function()
                            return vim.fn.strftime("%Y/%m/%d %H:%M:%S")
                        end,
                        separator = { left = "" },
                        color = "lualine_b_normal",
                    },
                },
                lualine_z = {},
            }

            local status_bar = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            }

            require("lualine").setup {
                options = {
                    theme = "auto",
                    globalstatus = true,
                    refresh = {
                        statusline = 200,
                        tabline = 200,
                        winbar = 200,
                    },
                },
                sections = status_line,
                inactive_section = status_line,
                tabline = status_tab,
                winbar = status_bar,
                inactive_winbar = status_bar,
                extensions = {
                    "lazy",
                    "mason",
                    "oil",
                    "quickfix",
                    "toggleterm",
                },
            }
        end,
    },
}
