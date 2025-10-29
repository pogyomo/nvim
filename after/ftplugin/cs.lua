-- Disable keyword highlight by lsp, as csharp_ls highlight builtin types as keyword.
-- Keyword is already highlighted by tree-sitter, so it's no problem.
vim.api.nvim_set_hl(0, "@lsp.type.keyword.cs", {})
