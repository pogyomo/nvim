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
        },
        format_on_save = {
            lsp_fallback = true,
            timeout_ms = 500,
        },
    },
    config = function(_, opts)
        local module = require("utils.module")
        local mods = module.require {
            "conform",
            "mason-registry",
        }

        local ensure_installed = {
            "clang-format",
            "stylua",
        }

        for _, name in ipairs(ensure_installed) do
            local pkg = mods["mason-registry"].get_package(name)
            if pkg:is_installed() then
                goto continue
            end
            vim.notify(("[formatter.lua] installing %s"):format(name))
            pkg:install():once("closed", function()
                if pkg:is_installed() then
                    vim.notify(
                        ("[formatter.lua] %s was successfully installed"):format(
                            name
                        )
                    )
                else
                    vim.notify(
                        ("[formatter.lua] failed to install %s"):format(name),
                        vim.log.levels.ERROR
                    )
                end
            end)
            ::continue::
        end

        mods["conform"].setup(opts)
    end,
}
