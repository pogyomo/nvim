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
        lazy = true,
        dependencies = {
            { "pogyomo/winresize.nvim", dev = true },
        },
        config = function()
            local submode = require("submode")
            local winresize = require("winresize")

            ---Just a wrapper of resize for keymap.
            ---@param key "left" | "right" | "up" | "down"
            local function resize_rhs(key)
                return function()
                    local amount = (key == "left" or key == "right") and 2 or 1
                    winresize.resize(0, amount, key)
                end
            end

            vim.keymap.set("n", "<Leader>r", "<Plug>(submode-win-resizer)")
            submode.create("WinResizer", {
                mode = "n",
                enter = "<Plug>(submode-win-resizer)",
                leave = { "q", "<ESC>" },
            }, function(default)
                default("h", resize_rhs("left"))
                default("j", resize_rhs("down"))
                default("k", resize_rhs("up"))
                default("l", resize_rhs("right"))
            end)

            submode.create("DocReader", {
                mode = "n",
            }, function(default)
                default("<Enter>", "<C-]>")
                default("u", "<cmd>po<cr>")
                default("r", "<cmd>ta<cr>")
                default("U", "<cmd>ta<cr>")
                default("q", "<cmd>q<cr>")
            end)
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
