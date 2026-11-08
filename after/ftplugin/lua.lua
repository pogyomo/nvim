-- Disable keyword highlight by lsp, as emmylua_ls highlight builtin types as keyword.
-- Keyword is already highlighted by tree-sitter, so it's no problem.
vim.api.nvim_set_hl(0, "@lsp.type.keyword.lua", {})

-- Annotations like @param should be highlighted by semantic tokens.
vim.api.nvim_set_hl(
    0,
    "@lsp.typemod.keyword.documentation.lua",
    { link = "@lsp.type.keyword" }
)
