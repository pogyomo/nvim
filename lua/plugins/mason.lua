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

        local event = require("helpers.event")
        local registry = require("mason-registry")
        local bridge = require("helpers.bridge")
        local settings = require("helpers.settings")
        local global_settings = settings.get_global_settings()

        -- Collect packages that should be installed
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

        --- Check if package should be installed
        ---
        --- @param spec {name: string, version?: string} Package spec
        local function should_install_package(spec)
            local name = spec["name"]
            local version = spec["version"] or "*"

            if not registry.has_package(name) then
                return false
            end

            -- Check if package should be installed.
            -- Install if not installed, or installed but different version.
            local pkg = registry.get_package(name)
            if
                pkg:is_installed()
                and (version == "*" or pkg:get_installed_version() == version)
            then
                return false
            end

            return true
        end

        --- Install package
        ---
        --- @param spec {name: string, version?: string} Package spec
        --- @param callback function Callback called when install finished
        local function install_package(spec, callback)
            local name = spec["name"]
            local version = spec["version"] or "*"
            local pkg = registry.get_package(name)

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
                    callback()
                end)
            )
        end

        -- Collec package specs that should be installed
        local should_install = {}
        for _, spec in ipairs(ensure_installed) do
            if should_install_package(spec) then
                should_install[#should_install + 1] = spec
            end
        end

        -- If no package should be installed, notify and return early
        if #should_install == 0 then
            vim.schedule(function()
                event.emit("auto_install_finished")
            end)
            return
        end

        -- Install packages
        local install_finished = 0
        for _, spec in ipairs(should_install) do
            install_package(spec, function()
                install_finished = install_finished + 1
                if install_finished < #should_install then
                    return
                end

                -- Notify install finished
                event.emit("auto_install_finished")
            end)
        end
    end,
}
