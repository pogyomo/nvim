return function()
    local is_ok, ts = pcall(require, "nvim-treesitter.configs")
    if not is_ok then
        return
    end

    ts.setup{
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
        }
    }
end
