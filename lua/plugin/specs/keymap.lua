return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup()
            require("cmp").event:on(
                "confirm_done",
                require("nvim-autopairs.completion.cmp").on_confirm_done()
            )
        end,
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                search = {
                    enabled = true,
                },
            },
        },
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        opts = {},
    },
    {
        "pogyomo/submode.nvim",
        dev = true,
        dependencies = {
            { "pogyomo/winresize.nvim", dev = true },
        },
        config = function()
            local submode = require("submode")
            local winresize = require("winresize")

            submode.setup()

            ---Just a wrapper of resize for keymap.
            ---@param key "left" | "right" | "up" | "down"
            local function resize_rhs(key)
                return function()
                    winresize.resize(0, 2, 1, key)
                end
            end

            vim.keymap.set("n", "<Leader>r", "<Plug>(submode-win-resizer)")
            submode.create("WinResizer", {
                mode = "n",
                enter = "<Plug>(submode-win-resizer)",
                leave = { "q", "<ESC>" },
            }, {
                lhs = "h",
                rhs = resize_rhs("left"),
            }, {
                lhs = "j",
                rhs = resize_rhs("down"),
            }, {
                lhs = "k",
                rhs = resize_rhs("up"),
            }, {
                lhs = "l",
                rhs = resize_rhs("right"),
            })

            submode.create("DocReader", {
                mode = "n",
            }, {
                lhs = "<Enter>",
                rhs = "<C-]>",
            }, {
                lhs = "u",
                rhs = "<cmd>po<cr>",
            }, {
                lhs = { "r", "U" },
                rhs = "<cmd>ta<cr>",
            }, {
                lhs = "q",
                rhs = "<cmd>q<cr>",
            })
            vim.api.nvim_create_augroup("DocReaderAugroup", {})
            vim.api.nvim_create_autocmd("BufEnter", {
                group = "DocReaderAugroup",
                callback = function()
                    if vim.opt.ft:get() == "help" and not vim.bo.modifiable then
                        submode.enter("DocReader")
                    end
                end,
            })
            vim.api.nvim_create_autocmd({ "BufLeave", "CmdwinEnter" }, {
                group = "DocReaderAugroup",
                callback = function()
                    if submode.mode() == "DocReader" then
                        submode.leave()
                    end
                end,
            })
        end,
    },
}
