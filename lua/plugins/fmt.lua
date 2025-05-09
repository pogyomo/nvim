return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    dependencies = {
        "williamboman/mason.nvim",
    },
    opts = {
        formatters_by_ft = {
            cpp = { "clang_format" },
            css = { "prettier" },
            html = { "prettier" },
            javascript = { "prettier" },
            json = { "prettier" },
            lua = { "stylua" },
            markdown = { "prettier" },
            rust = { "rustfmt" },
            typescript = { "prettier" },
        },
        default_format_opts = {
            lsp_format = "fallback",
            timeout_ms = 500,
        },
    },
    init = function()
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("format-on-save", {}),
            callback = function(args)
                require("conform").format { bufnr = args.buf }
            end,
        })

        vim.api.nvim_create_user_command("EnableFormatOnSave", function()
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("format-on-save", {}),
                callback = function(args)
                    require("conform").format { bufnr = args.buf }
                end,
            })
        end, {})

        vim.api.nvim_create_user_command("DisableFormatOnSave", function()
            if vim.fn.exists("#format-on-save") == 1 then
                vim.api.nvim_del_augroup_by_name("format-on-save")
            end
        end, {})

        local ensure_installed = {
            "clang-format",
            "prettier",
            "stylua",
        }

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
    end,
}
