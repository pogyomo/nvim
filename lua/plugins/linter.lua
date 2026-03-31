return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")
        local settings = require("helpers.settings")
        local ft_settings = settings.get_ft_settings()

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

        -- Run linter on write
        vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
            group = vim.api.nvim_create_augroup("pogyomo.linter", {}),
            callback = function()
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
                    if linter == "selene" then
                        -- selene needs to be executed where selene.toml exists
                        opts["cwd"] = vim.fs.root(bufnr, "selene.toml")
                    end
                    lint.try_lint(linter, opts)
                end
            end,
        })
    end,
}
