return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    dependencies = {
        "williamboman/mason.nvim",
    },
    opts = {
        formatters_by_ft = {
            rust = { "rustfmt" },
            cpp = { "clang_format" },
            lua = { "stylua" },
            typescript = { "prettier" },
        },
        format_on_save = {
            lsp_fallback = true,
            timeout_ms = 500,
        },
    },
    init = function()
        local mason_registry = require("mason-registry")

        local ensure_installed = {
            "clang-format",
            "stylua",
            "prettier",
        }
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
    end,
}
