return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    dependencies = {
        "williamboman/mason.nvim",
    },
    config = function()
        local helper = require("helpers.settings")
        local conform = require("conform")
        local global_settings = helper.get_global_settings()
        local ft_settings = helper.get_ft_settings()

        -- Collect formatters infomations
        local ensure_installed = {}
        local formatters_by_ft = {}
        local format_on_save_by_ft = {}
        for fts, value in pairs(ft_settings) do
            if value["fmt"] then
                local provider = value["fmt"]["provider"]

                if provider and value["fmt"]["ensure_installed"] then
                    if not vim.list_contains(ensure_installed, provider) then
                        ensure_installed[#ensure_installed + 1] = provider
                    end
                end

                local use_lsp_format = value["fmt"]["use_lsp_format"]
                for _, ft in ipairs(fts) do
                    local lsp_format = use_lsp_format and "fallback" or "never"
                    if provider then
                        formatters_by_ft[ft] = {
                            provider,
                            lsp_format = lsp_format,
                        }
                    else
                        formatters_by_ft[ft] = {
                            lsp_format = lsp_format,
                        }
                    end
                    format_on_save_by_ft[ft] = value["fmt"]["format_on_save"]
                end
            end
        end

        -- Install formatters
        local mason_registry = require("mason-registry")
        for _, name in ipairs(ensure_installed) do
            if not mason_registry.has_package(name) then
                goto continue
            end
            local pkg = mason_registry.get_package(name)
            if pkg:is_installed() then
                goto continue
            end
            vim.notify(("[formatter.lua] installing %s"):format(name))
            pkg:install():once(
                "closed",
                vim.schedule_wrap(function()
                    if pkg:is_installed() then
                        vim.notify(
                            ("[formatter.lua] %s was successfully installed"):format(
                                name
                            )
                        )
                    else
                        vim.notify(
                            ("[formatter.lua] failed to install %s"):format(
                                name
                            ),
                            vim.log.levels.ERROR
                        )
                    end
                end)
            )
            ::continue::
        end

        -- Configure formatters
        local use_lsp_format = global_settings["fmt"]["use_lsp_format"]
        conform.setup {
            formatters_by_ft = formatters_by_ft,
            default_format_opts = {
                lsp_format = use_lsp_format and "fallback" or "never",
                timeout_ms = 500,
            },
        }

        -- Configure format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("format-on-save", {}),
            callback = function(args)
                if format_on_save_by_ft[vim.bo.filetype] then
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
