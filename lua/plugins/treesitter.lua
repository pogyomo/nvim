return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
        if vim.fn.executable("tree-sitter") == 0 then
            -- NOTE:
            -- Install hungs if tree-sitter is not found.
            -- See https://github.com/nvim-treesitter/nvim-treesitter/issues/8010
            error("no tree-sitter executable found")
        end

        --- @param lang string
        --- @return boolean
        local function has_highlights(lang)
            return #vim.treesitter.query.get_files(lang, "highlights") > 0
        end

        --- @param lang string
        --- @return boolean
        local function has_indents(lang)
            return #vim.treesitter.query.get_files(lang, "indents") > 0
        end

        local ft_use_vim_regex_indent = {
            "php",
        }

        -- Register parsers not in nvim-treesitter
        vim.api.nvim_create_autocmd("User", {
            pattern = "TSUpdate",
            callback = function()
                require("nvim-treesitter.parsers").ld65 = {
                    install_info = {
                        url = "https://github.com/pogyomo/tree-sitter-ld65",
                        revision = "edf0bae7a8b85c16488af26da7fdb56b1bb3e68d",
                        queries = "queries",
                    },
                    tier = 2,
                }
            end,
        })

        require("nvim-treesitter").install {
            "c",
            "cpp",
            "css",
            "html",
            "java",
            "javascript",
            "json",
            "ld65",
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
            group = vim.api.nvim_create_augroup("treesitter-start-by-ft", {}),
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
                    if ft == "php" then
                        -- Indentation of html in php broken with this option set.
                        vim.bo[ev.buf].indentexpr = ""
                    end
                elseif has_indents(lang) then
                    local e = "v:lua.require'nvim-treesitter'.indentexpr()"
                    vim.bo[ev.buf].indentexpr = e
                end
            end,
        })
    end,
}
