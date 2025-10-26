return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
        local settings = require("helpers.settings")
        local global_settings = settings.get_global_settings()

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

        -- Register parsers not in nvim-treesitter
        vim.api.nvim_create_autocmd("User", {
            pattern = "TSUpdate",
            callback = function()
                require("nvim-treesitter.parsers").ld65 = {
                    --- @diagnostic disable-next-line
                    install_info = {
                        url = "https://github.com/pogyomo/tree-sitter-ld65",
                        queries = "queries",
                    },
                    tier = 2,
                }
                require("nvim-treesitter.parsers").ca65 = {
                    --- @diagnostic disable-next-line
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
                end
            end,
        })
    end,
}
