return function()
    -- Got a true color.
    vim.o.termguicolors = true

    -- Settings for this colorscheme
    vim.g.sonokai_style = "shusia"
    vim.g.sonokai_disable_italic_comment = true
    vim.g.sonokai_better_performance = true
    vim.cmd.colorscheme("sonokai")
end
