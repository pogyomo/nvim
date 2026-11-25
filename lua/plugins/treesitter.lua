return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
        local settings = require("modules.settings")
        local global_settings = settings.get_global_settings()

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

        --- @param node TSNode
        --- @return boolean
        local function is_php_node_has_html(node)
            if node:type() == "text" then
                return true
            end

            for child in node:iter_children() do
                if is_php_node_has_html(child) then
                    return true
                end
            end
        end

        --- @param buf integer
        --- @return boolean
        local function is_php_has_html(buf)
            local parser = vim.treesitter.get_parser(buf, "php")
            local trees = parser:parse()
            for _, tree in ipairs(trees) do
                if is_php_node_has_html(tree:root()) then
                    return true
                end
            end
            return false
        end

        -- Register parsers not in nvim-treesitter
        vim.api.nvim_create_autocmd("User", {
            pattern = "TSUpdate",
            callback = function()
                require("nvim-treesitter.parsers").ld65 = {
                    install_info = {
                        url = "https://github.com/pogyomo/tree-sitter-ld65",
                        queries = "queries",
                    },
                    tier = 2,
                }
                require("nvim-treesitter.parsers").ca65 = {
                    install_info = {
                        url = "https://github.com/pogyomo/tree-sitter-ca65",
                        queries = "queries",
                    },
                    tier = 2,
                }
            end,
        })

        -- Install parsers
        require("nvim-treesitter").install(global_settings["tree-sitter.uses"])

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("pogyomo.treesitter", {}),
            callback = function(ev)
                local ft = vim.bo[ev.buf].filetype
                local lang = vim.treesitter.language.get_lang(ft)
                if not lang then
                    return
                end

                if has_highlights(lang) then
                    vim.treesitter.start(ev.buf, lang)
                end

                local indent = global_settings["tree-sitter.indent"]
                if
                    not indent["enabled"]
                    or vim.list_contains(indent["exclude"], ft)
                then
                    vim.bo[ev.buf].syntax = "on"
                    vim.bo[ev.buf].indentexpr = ""
                elseif has_indents(lang) then
                    local e = "v:lua.require'nvim-treesitter'.indentexpr()"
                    vim.bo[ev.buf].indentexpr = e

                    -- TODO:
                    -- Indentation of html in php still broken.
                    -- Disable tree-sitter indent if it contains html.
                    if lang == "php" and is_php_has_html(ev.buf) then
                        vim.bo[ev.buf].syntax = "on"
                        vim.bo[ev.buf].indentexpr = ""
                    end

                    -- NOTE:
                    -- In following, when you insert `:` for typing `:=`, the indentation of `var a :` breaks.
                    -- ```gdscript
                    -- func hoge() -> void:
                    --     if true:
                    --         var a |
                    -- ```
                    -- Prevent reindentation when type `:`, so this problem doesn't happen.
                    if lang == "gdscript" then
                        vim.opt_local.indentkeys:remove { "<:>" }
                    end
                end
            end,
        })
    end,
}
