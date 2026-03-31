-- Convert lsp/formatter/linter specific names into mason package names.
local M = {
    -- lspconfig.nvim to mason.nvim mapping
    lspconfig_to_mason = {
        ["clangd"] = "clangd",
        ["cmake"] = "cmake-language-server",
        ["cssls"] = "css-lsp",
        ["html"] = "html-lsp",
        ["ts_ls"] = "typescript-language-server",
        ["jsonls"] = "json-lsp",
        ["intelephense"] = "intelephense",
        ["rust_analyzer"] = "rust-analyzer",
        ["lua_ls"] = "lua-language-server",
        ["gopls"] = "gopls",
        ["tailwindcss"] = "tailwindcss-language-server",
        ["pyright"] = "pyright",
        ["csharp_ls"] = "csharp-language-server",
    },

    -- conform.nvim to mason.nvim mapping
    conform_to_mason = {
        ["clang-format"] = "clang-format",
        ["prettier"] = "prettier",
        ["rustfmt"] = "rustfmt",
        ["stylua"] = "stylua",
        ["gofmt"] = "gofmt",
        ["black"] = "black",
        ["isort"] = "isort",
        ["csharpier"] = "csharpier",
    },

    -- nvim-lint to mason.nvim mapping
    lint_to_mason = {
        ["selene"] = "selene",
    },
}

--- Get mason.nvim style lsp name from lspconfig.nvim uses name
---
--- @param lspconfig_name string lspconfig.nvim uses name
--- @return string # mason.nvim uses name
function M.convert_lspconfig_to_mason(lspconfig_name)
    if M.lspconfig_to_mason[lspconfig_name] == nil then
        return lspconfig_name
    end
    return M.lspconfig_to_mason[lspconfig_name]
end

--- Get mason.nvim style formatter name from conform.nvim uses name
---
--- @param conform_name string conform.nvim uses name
--- @return string # mason.nvim uses name
function M.convert_conform_to_mason(conform_name)
    if M.conform_to_mason[conform_name] == nil then
        return conform_name
    end
    return M.conform_to_mason[conform_name]
end

--- Get mason.nvim style formatter name from lint.nvim uses name
---
--- @param lint_name string lint.nvim uses name
--- @return string # mason.nvim uses name
function M.convert_lint_to_mason(lint_name)
    if M.lint_to_mason[lint_name] == nil then
        return lint_name
    end
    return M.lint_to_mason[lint_name]
end

return M
