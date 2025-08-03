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
        "windwp/nvim-ts-autotag",
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        opts = {},
    },
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        opts = {
            custom_textobjects = {
                ["$"] = { "%b$$", "^.().*().$" },
            },
        },
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
                    local amount = (key == "left" or key == "right") and 4 or 2
                    winresize.resize(0, amount, key)
                end
            end

            submode.create("win-resizer", {
                mode = "n",
                enter = "<Leader>r",
                leave = { "q", "<ESC>" },
                default = function(register)
                    register("h", resize_rhs("left"))
                    register("j", resize_rhs("down"))
                    register("k", resize_rhs("up"))
                    register("l", resize_rhs("right"))
                end,
            })
        end,
    },
}
