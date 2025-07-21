return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    init = function()
        --- @param lang string
        --- @return boolean
        local function has_highlights(lang)
            return #vim.treesitter.query.get_files(lang, "highlights") > 0
        end

        --- @param lang string
        --- @return boolean
        local function has_indent(lang)
            return #vim.treesitter.query.get_files(lang, "indents") > 0
        end

        local ft_use_vim_regex_indent = {
            "php",
        }

        require("nvim-treesitter").install {
            "c",
            "cpp",
            "css",
            "html",
            "java",
            "javascript",
            "json",
            "lua",
            "markdown",
            "php",
            "phpdoc",
            "query",
            "rust",
            "sql",
            "toml",
            "typescript",
            "vimdoc",
            "zig",
        }

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("", {}),
            callback = function(ev)
                local ft = vim.bo[ev.buf].filetype
                local lang = vim.treesitter.language.get_lang(ft)
                if not lang then
                    return
                end

                if has_highlights(lang) then
                    vim.treesitter.start(ev.buf, lang)
                end

                if vim.list_contains(ft_use_vim_regex_indent, ft) then
                    vim.bo[ev.buf].syntax = "on"
                elseif has_indent(lang) then
                    local e = "v:lua.require'nvim-treesitter'.indentexpr()"
                    vim.bo[ev.buf].indentexpr = e
                end
            end,
        })
    end,
}
