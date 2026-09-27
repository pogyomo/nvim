return {
    "mfussenegger/nvim-lint",
    init = function()
        local lint = require("lint")
        local event = require("helpers.event")
        local settings = require("helpers.settings")
        local global_settings = settings.get_global_settings()
        local ft_settings = settings.get_ft_settings()

        -- Load linter config after mason installed linters.
        -- Prevent `linter unavaliable` errors while installing linters.
        event.once("auto_install_finished", function()
            -- Collect linter config
            local config_by_linter = {}
            for name, setting in pairs(global_settings["linter.providers"]) do
                config_by_linter[name] = setting["config"]
            end

            -- Collect filetype specific linter imfomations
            local linters_by_ft = {}
            for fts, value in pairs(ft_settings) do
                for _, ft in ipairs(fts) do
                    linters_by_ft[ft] = {}
                    for _, provider in ipairs(value["linter.uses"]) do
                        linters_by_ft[ft][#linters_by_ft[ft] + 1] = provider
                    end
                end
            end

            local function do_lint()
                -- Check if linter exists for the file
                local bufnr = vim.api.nvim_get_current_buf()
                local ft = vim.bo[bufnr].filetype
                if linters_by_ft[ft] == nil then
                    return
                end

                -- Execute linters in series
                local linters = linters_by_ft[vim.bo[bufnr].filetype]
                for _, linter in ipairs(linters) do
                    local opts = {}
                    if config_by_linter[linter]["root_marker"] ~= nil then
                        -- Some linter need to be executed on directory where specific file exists.
                        opts["cwd"] = vim.fs.root(
                            bufnr,
                            config_by_linter[linter]["root_marker"]
                        )
                    end
                    lint.try_lint(linter, opts)
                end
            end

            -- Run linter on write
            vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
                group = vim.api.nvim_create_augroup("pogyomo.lint", {}),
                callback = do_lint,
            })

            -- Execute linters once install success.
            do_lint()
        end)
    end,
}
