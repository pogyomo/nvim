-- Tab and indent
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.cindent = true

-- Disable mouse
vim.o.mouse = ""

-- Config minimal spaces between cursor and top/bottom.
vim.o.scrolloff = 5

-- Visual
vim.o.showcmd = false
vim.o.number = true
vim.o.cursorline = true
vim.o.termguicolors = true
vim.o.signcolumn = "yes"

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Folding
vim.o.foldmethod = "marker"

-- Quickfix
vim.o.qftf = "{info -> v:lua._G.qftf(info)}"

---Formatting function can be used in `qftf`.
---@param info table
---@return string[]
function _G.qftf(info)
    local items
    if info.quickfix == 1 then
        items = vim.fn.getqflist({ id = info.id, items = 0 }).items
    else
        items = vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
    end

    ---Append spaces to the left of `s` so its length become `n`.
    ---@param s string
    ---@param n integer
    ---@return string
    local function lalign(s, n)
        while s:len() < n do
            s = " " .. s
        end
        return s
    end

    ---Append spaces to the right of `s` so its length become `n`.
    ---@param s string
    ---@param n integer
    ---@return string
    local function ralign(s, n)
        while s:len() < n do
            s = s .. " "
        end
        return s
    end

    local elems = {}
    local fname_width = 0
    local lnum_width = 0
    local col_width = 0
    for idx = info.start_idx, info.end_idx, 1 do
        local item = items[idx]

        local fname = vim.fn.bufname(item.bufnr):gsub("^" .. vim.env.HOME, "~")
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
        local fname = ralign(elem.fname, fname_width)
        local lnum = lalign(elem.lnum, lnum_width)
        local col = ralign(elem.col, col_width)

        ret[#ret + 1] =
            string.format("%s │%s:%s│ %s", fname, lnum, col, elem.text)
    end

    return ret
end
