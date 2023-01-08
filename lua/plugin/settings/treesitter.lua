return function()
    local module = require("utils.module")
    local is_ok, mods = pcall(module.require, {
        { "nvim-treesitter.configs", as = "ts" }
    })
    if not is_ok then
        return
    end

    mods["ts"].setup{
        ensure_installed = {
            "bibtex",
            "c",
            "cpp",
            "go",
            "help",
            "java",
            "lua",
            "latex",
            "markdown",
            "rust",
            "zig"
        },

        highlight = {
            enable = true
        },

        rainbow = {
            enable = true,
            extended_mode = true
        }
    }
end
