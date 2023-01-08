return function()
    -- Change the style of this colorscheme.
    vim.g.sonokai_style = "shusia"

    -- Disable italic.
    vim.g.sonokai_enable_italic = false
    vim.g.sonokai_disable_italic_comment = true

    -- Make virtual text to be colorful.
    vim.g.sonokai_diagnostic_virtual_text = "colored"

    -- Reduce the loading time.
    vim.g.sonokai_better_performance = true

    -- Load this colorscheme
    vim.cmd.colorscheme("sonokai")
end
