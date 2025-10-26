return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    dependencies = {
        "mason-org/mason.nvim",
        "zapling/mason-conform.nvim",
    },
    config = function()
        local helper = require("helpers.settings")
        local conform = require("conform")
        local global_settings = helper.get_global_settings()
        local ft_settings = helper.get_ft_settings()

        -- Collect formatter infomations
        local ensure_installed = {}
        for name, setting in pairs(global_settings["fmt.providers"]) do
            if setting["ensure_installed"] then
                ensure_installed[#ensure_installed + 1] = name
            end
        end

        -- Collect filetype specific formatter imfomations
        local formatters_by_ft = {}
        local format_on_save_by_ft = {}
        for fts, value in pairs(ft_settings) do
            local use_lsp_format = value["fmt.use_lsp_format"]
            local lsp_format = use_lsp_format and "fallback" or "never"
            for _, ft in ipairs(fts) do
                formatters_by_ft[ft] = {
                    lsp_format = lsp_format,
                }
                for _, provider in ipairs(value["fmt.uses"]) do
                    formatters_by_ft[ft][#formatters_by_ft[ft] + 1] = provider
                end

                format_on_save_by_ft[ft] = value["fmt.format_on_save"]
            end
        end

        -- Configure formatters
        local use_lsp_format = global_settings["fmt.use_lsp_format"]
        conform.setup {
            formatters_by_ft = formatters_by_ft,
            default_format_opts = {
                lsp_format = use_lsp_format and "fallback" or "never",
                timeout_ms = 500,
            },
        }

        -- Install formatters
        require("mason-conform").setup {}

        -- Configure format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("format-on-save", {}),
            callback = function(args)
                if format_on_save_by_ft[vim.bo[args.buf].filetype] then
                    require("conform").format { bufnr = args.buf }
                end
            end,
        })
        vim.api.nvim_create_user_command("EnableFormatOnSave", function()
            format_on_save_by_ft[vim.bo.filetype] = true
        end, {})
        vim.api.nvim_create_user_command("DisableFormatOnSave", function()
            format_on_save_by_ft[vim.bo.filetype] = false
        end, {})
    end,
}
