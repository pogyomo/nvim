return {
    "stevearc/conform.nvim",
    config = function()
        local conform = require("conform")
        local event = require("helpers.event")
        local settings = require("helpers.settings")
        local ft_settings = settings.get_ft_settings()
        local global_settings = settings.get_global_settings()

        -- Collect auto format settings.
        local auto_format_by_ft = {}
        for fts, value in pairs(ft_settings) do
            for _, ft in ipairs(fts) do
                auto_format_by_ft[ft] = value["formatter.auto_format"]
            end
        end

        -- Some commands for auto format
        vim.api.nvim_create_user_command("EnableAutoFormat", function()
            auto_format_by_ft[vim.bo.filetype] = true
        end, {})
        vim.api.nvim_create_user_command("DisableAutoFormat", function()
            auto_format_by_ft[vim.bo.filetype] = false
        end, {})

        -- Load formatter config after mason installed formatters.
        -- Prevent `formatter unavailable` warning while installing formatters.
        event.once("auto_install_finished", function()
            -- Collect formatter infomations
            for name, setting in pairs(global_settings["formatter.providers"]) do
                if vim.tbl_count(setting["config"]) ~= 0 then
                    conform.formatters[name] = {}
                    for key, value in pairs(setting["config"]) do
                        conform.formatters[name][key] = value
                    end
                end
            end

            -- Collect filetype specific formatter imfomations
            local formatters_by_ft = {}
            for fts, value in pairs(ft_settings) do
                local lsp_format = value["formatter.lsp_format"]
                for _, ft in ipairs(fts) do
                    formatters_by_ft[ft] = {}
                    for _, provider in ipairs(value["formatter.uses"]) do
                        formatters_by_ft[ft][#formatters_by_ft[ft] + 1] =
                            provider
                    end
                    formatters_by_ft[ft]["lsp_format"] = lsp_format
                end
            end

            -- Configure formatters
            conform.setup {
                format_after_save = function(bufnr)
                    if auto_format_by_ft[vim.bo[bufnr].filetype] then
                        return {}
                    end
                end,
                formatters_by_ft = formatters_by_ft,
            }
        end)
    end,
}
