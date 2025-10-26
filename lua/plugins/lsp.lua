return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        dependencies = {
            "Bilal2453/luvit-meta",
        },
        opts = {
            library = {
                "luvit-meta/library",
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason-org/mason-lspconfig.nvim",
            "stevearc/conform.nvim",
        },
        config = function()
            local settings = require("helpers.settings")
            local global_settings = settings.get_global_settings()
            local ft_settings = settings.get_ft_settings()

            -- Keymaps for lsp actions
            -- reference: https://zenn.dev/botamotch/articles/21073d78bc68bf
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("register-lsp-keymaps", {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf }

                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "gf", function()
                        require("conform").format { async = true }
                    end, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
                    vim.keymap.set("n", "gn", vim.lsp.buf.rename, opts)
                    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
                end,
            })

            -- Add capabilities for all server.
            vim.lsp.config("*", {
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })

            -- Collect lsp infomations
            local ensure_installed = {}
            for name, setting in pairs(global_settings["lsp.providers"]) do
                if setting["ensure_installed"] then
                    ensure_installed[#ensure_installed + 1] = name
                end
                vim.lsp.config(name, setting["config"])
            end

            -- Collect filetype specific lsp infomations
            for fts, value in pairs(ft_settings) do
                for _, name in ipairs(value["lsp.uses"]) do
                    vim.lsp.config(name, {
                        filetypes = fts,
                    })
                end
            end

            -- Enable lsp
            for _, name in ipairs(ensure_installed) do
                vim.lsp.enable(name)
            end

            -- Install required servers
            require("mason-lspconfig").setup {
                automatic_enable = {
                    exclude = ensure_installed,
                },
                ensure_installed = ensure_installed,
            }
        end,
    },
}
