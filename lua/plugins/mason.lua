return {
    "mason-org/mason.nvim",
    opts = {
        ui = {
            border = "rounded",
            height = 0.8,
        },
    },
    config = function(_, opts)
        require("mason").setup(opts)

        local registry = require("mason-registry")
        local bridge = require("helpers.bridge")
        local settings = require("helpers.settings")
        local global_settings = settings.get_global_settings()

        -- Collect packages that should be installed.
        local ensure_installed = {}
        for name, setting in pairs(global_settings["lsp.providers"]) do
            if setting["ensure_installed"] then
                ensure_installed[#ensure_installed + 1] = {
                    name = bridge.convert_lspconfig_to_mason(name),
                    version = setting["version"],
                }
            end
        end
        for name, setting in pairs(global_settings["formatter.providers"]) do
            if setting["ensure_installed"] then
                ensure_installed[#ensure_installed + 1] = {
                    name = bridge.convert_conform_to_mason(name),
                    version = setting["version"],
                }
            end
        end
        for name, setting in pairs(global_settings["linter.providers"]) do
            if setting["ensure_installed"] then
                ensure_installed[#ensure_installed + 1] = {
                    name = bridge.convert_lint_to_mason(name),
                    version = setting["version"],
                }
            end
        end

        --- Install package.
        ---
        --- @param spec {name: string, version?: string}
        local function install_package(spec)
            local name = spec["name"]
            local version = spec["version"] or "*"

            if not registry.has_package(name) then
                return
            end

            -- Check if package should be installed.
            -- Install if not installed, or installed but different version.
            local pkg = registry.get_package(name)
            if
                pkg:is_installed()
                and (version == "*" or pkg:get_installed_version() == version)
            then
                return
            end

            vim.notify(string.format("[mason.lua] installing %s", pkg.name))
            pkg:install({ version = version ~= "*" and version or nil }):once(
                "closed",
                vim.schedule_wrap(function()
                    if pkg:is_installed() then
                        vim.notify(
                            string.format(
                                "[mason.lua] %s was successfully installed",
                                pkg.name
                            )
                        )
                    else
                        vim.notify(
                            string.format(
                                "[mason.lua] failed to install %s",
                                pkg.name
                            )
                        )
                    end
                end)
            )
        end

        -- Install packages if not installed.
        for _, spec in ipairs(ensure_installed) do
            install_package(spec)
        end
    end,
}
