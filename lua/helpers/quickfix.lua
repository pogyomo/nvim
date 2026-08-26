local M = {}
local ns = vim.api.nvim_create_namespace("pogyomo.quickfix")

--- Do highlight to specified buffer
local function do_highlight(buf, highlights)
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    for _, highlight in ipairs(highlights) do
        vim.hl.range(
            buf,
            ns,
            highlight.hlgroup,
            { highlight.line, highlight.start_column },
            { highlight.line, highlight.end_column }
        )
    end
end

--- Get list from either quickfix or location list
local function get_list(info)
    local what = { id = info.id, items = 0, qfbufnr = 0 }
    if info.quickfix == 1 then
        return vim.fn.getqflist(what)
    else
        return vim.fn.getloclist(info.winid, what)
    end
end

--- Format function for `quickfixtextfunc`
function M.format(info)
    local list = get_list(info)
    local items = list.items
    local bufnr = list.qfbufnr

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

        local fname = vim.fn.bufname(item.bufnr):gsub("^" .. vim.env.HOME, "~")
        fname_width = math.max(fname_width, fname:len())

        local lnum = string.format("%d", item.lnum)
        lnum_width = math.max(lnum_width, lnum:len())

        local col = string.format("%d", item.col)
        col_width = math.max(col_width, col:len())

        table.insert(elems, {
            fname = fname,
            lnum = lnum,
            col = col,
            text = item.text,
        })
    end

    local highlights = {}
    for line = 0, #items, 1 do
        local start_column = 0
        local end_column = fname_width + 1
        table.insert(highlights, {
            line = line,
            start_column = start_column,
            end_column = end_column,
            hlgroup = "Directory",
        })

        start_column = end_column
        end_column = start_column
        table.insert(highlights, {
            line = line,
            start_column = start_column,
            end_column = end_column,
            hlgroup = "Delimiter",
        })

        start_column = end_column + 1
        end_column = start_column + 3 + lnum_width + col_width
        table.insert(highlights, {
            line = line,
            start_column = start_column,
            end_column = end_column,
            hlgroup = "Number",
        })

        start_column = end_column
        end_column = start_column
        table.insert(highlights, {
            line = line,
            start_column = start_column,
            end_column = end_column,
            hlgroup = "Delimiter",
        })

        start_column = end_column + 1
        end_column = start_column + 10000
        table.insert(highlights, {
            line = line,
            start_column = start_column,
            end_column = end_column,
            hlgroup = "Normal",
        })
    end
    vim.schedule(function()
        do_highlight(bufnr, highlights)
    end)

    local ret = {}
    for _, elem in ipairs(elems) do
        local fname = spaces(elem.fname, fname_width, false)
        local lnum = spaces(elem.lnum, lnum_width, true)
        local col = spaces(elem.col, col_width, false)

        table.insert(
            ret,
            string.format("%s │%s:%s│ %s", fname, lnum, col, elem.text)
        )
    end

    return ret
end

return M
