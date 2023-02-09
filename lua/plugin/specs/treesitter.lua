-- NOTE: When I scrolling second half of huge help file, the scroll slow down.
--       This problem doesn't happen if I disable treesitter highlight on the file.
--       Also, this only happen when I using nightly neovim (using 0.8.2 doesn't cause the problem).
--       This may caused by semantic token support.

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        -- TODO: This plugin was archived, so I need to find alternative plugin like this.
        "p00f/nvim-ts-rainbow"
    },
    opts = {
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
            "typescript",
            "rust",
            "zig"
        },

        highlight = {
            enable = true,
            disable = function(lang, bufnr)
                -- NOTE: Disable treesitter on help file if the size of file is too large.
                --       This is temporary treatment. See above NOTE for the reason.
                if lang == "help" then
                    local line = vim.api.nvim_buf_call(bufnr, function()
                        return vim.fn.line("$")
                    end)
                    return line > 3000
                end

                -- NOTE: I need to disable treesitter on command window.
                --       See: https://github.com/nvim-treesitter/nvim-treesitter/issues/3961
                local bufname = vim.api.nvim_buf_get_name(bufnr)
                return lang == "vim" and bufname:match("%[Command Line%]")
            end
        },

        rainbow = {
            enable = true,
            extended_mode = true
        }
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end
}
