return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
        formatters_by_ft = {
            rust = { "rustfmt" },
            cpp = { "clang_format" },
            lua = { "stylua" },
        },
        format_on_save = {
            lsp_fallback = false,
            timeout_ms = 500,
        },
    },
}
