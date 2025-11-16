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
                            namespace = { "diagnostic" },
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
            "SmiteshP/nvim-navic",
        },
        init = function()
            -- Suppress flick on startup
            vim.o.winbar = " "
        end,
        config = function()
            local navic = require("nvim-navic")

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("nvim-navic-on-attach", {}),
                callback = function(ev)
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)
                    if
                        client
                        and client.server_capabilities.documentSymbolProvider
                    then
                        navic.attach(client, ev.buf)
                    end
                end,
            })

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
                    {
                        function()
                            local clients = vim.lsp.get_clients {
                                bufnr = vim.fn.bufnr("%"),
                            }
                            return vim.iter(clients)
                                :map(function(client)
                                    return client.name
                                end)
                                :join(" ")
                        end,
                        icon = "",
                    },
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
                lualine_c = {
                    function()
                        if navic.is_available() then
                            return navic.get_location { highlight = true }
                        else
                            return " " -- don't hide winbar if location not found
                        end
                    end,
                },
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
