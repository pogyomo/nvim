return {
    {
        "folke/todo-comments.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            keywords = {
                REVIEW = { icon = " ", color = "info" },
                CHANGED = { icon = " ", color = "hint" },
            },
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            scope = {
                enabled = false,
            },
        },
    },
    {
        "HiPhish/rainbow-delimiters.nvim",
    },
    {
        "j-hui/fidget.nvim",
        opts = {
            notification = {
                override_vim_notify = true,
                window = {
                    zindex = 100,
                },
            },
        },
    },
    {
        "folke/tokyonight.nvim",
        opts = { style = "storm" },
        config = function(_, opts)
            require("tokyonight").setup(opts)
            vim.cmd.colorscheme("tokyonight")
        end,
    },
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {},
        init = function()
            -- Better visual for quickfix
            vim.o.qftf = "{info -> v:lua._G.qftf(info)}"

            ---Formatting function can be used in `qftf`.
            ---@param info table
            ---@return string[]
            function _G.qftf(info)
                local items
                if info.quickfix == 1 then
                    items = vim.fn.getqflist({ id = info.id, items = 0 }).items
                else
                    items = vim.fn.getloclist(
                        info.winid,
                        { id = info.id, items = 0 }
                    ).items
                end

                local function spaces(s, n, left)
                    while s:len() < n do
                        if left then
                            s = " " .. s
                        else
                            s = s .. " "
                        end
                    end
                    return s
                end

                local elems = {}
                local fname_width = 0
                local lnum_width = 0
                local col_width = 0
                for idx = info.start_idx, info.end_idx, 1 do
                    local item = items[idx]

                    local fname = vim.fn
                        .bufname(item.bufnr)
                        :gsub("^" .. vim.env.HOME, "~")
                    fname_width = math.max(fname_width, fname:len())

                    local lnum = string.format("%d", item.lnum)
                    lnum_width = math.max(lnum_width, lnum:len())

                    local col = string.format("%d", item.col)
                    col_width = math.max(col_width, col:len())

                    elems[#elems + 1] = {
                        fname = fname,
                        lnum = lnum,
                        col = col,
                        text = item.text,
                    }
                end

                local ret = {}
                for _, elem in ipairs(elems) do
                    local fname = spaces(elem.fname, fname_width, false)
                    local lnum = spaces(elem.lnum, lnum_width, true)
                    local col = spaces(elem.col, col_width, false)

                    ret[#ret + 1] = string.format(
                        "%s │%s:%s│ %s",
                        fname,
                        lnum,
                        col,
                        elem.text
                    )
                end

                return ret
            end
        end,
    },
}
