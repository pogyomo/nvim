return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
        format_on_save = {
            lsp_fallback = true,
            timeout_ms = 500,
        }
    }
}
