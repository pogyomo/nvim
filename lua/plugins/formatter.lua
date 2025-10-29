return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    dependencies = {
        "mason-org/mason.nvim",
    },
    config = function()
        local settings = require("helpers.settings")
        local bridge = require("helpers.bridge")
        local conform = require("conform")
        local global_settings = settings.get_global_settings()
        local ft_settings = settings.get_ft_settings()

        -- Collect formatter infomations
        local ensure_installed = {}
        for name, setting in pairs(global_settings["formatter.providers"]) do
            if setting["ensure_installed"] then
                ensure_installed[#ensure_installed + 1] = name
            end
            if vim.tbl_count(setting["config"]) ~= 0 then
                conform.formatters[name] = {}
                for key, value in pairs(setting["config"]) do
                    conform.formatters[name][key] = value
                end
            end
        end

        -- Collect filetype specific formatter imfomations
        local formatters_by_ft = {}
        local auto_format_by_ft = {}
        for fts, value in pairs(ft_settings) do
            local lsp_format = value["formatter.lsp_format"]
            for _, ft in ipairs(fts) do
                formatters_by_ft[ft] = {}
                for _, provider in ipairs(value["formatter.uses"]) do
                    formatters_by_ft[ft][#formatters_by_ft[ft] + 1] =
                        bridge.get_conform_name(provider)
                end
                formatters_by_ft[ft]["lsp_format"] = lsp_format

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

        -- Configure formatters
        conform.setup {
            format_after_save = function(bufnr)
                if auto_format_by_ft[vim.bo[bufnr].filetype] then
                    return {}
                end
            end,
            formatters_by_ft = formatters_by_ft,
        }

        -- Install formatters
        local registry = require("mason-registry")
        for _, name in ipairs(ensure_installed) do
            if not registry.has_package(name) then
                goto continue
            end

            local pkg = registry.get_package(name)
            if pkg:is_installed() then
                goto continue
            end

            vim.notify(("[formatter.lua] installing %s"):format(pkg.name))
            pkg:install():once(
                "closed",
                vim.schedule_wrap(function()
                    if pkg:is_installed() then
                        vim.notify(
                            ("[formatter.lua] %s was successfully installed"):format(
                                pkg.name
                            )
                        )
                    else
                        vim.notify(
                            ("[formatter.lua] failed to install %s"):format(
                                pkg.name
                            )
                        )
                    end
                end)
            )
            ::continue::
        end
    end,
}
