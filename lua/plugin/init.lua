require("utils.install.packer").install(function()
    -- NOTE: If it is a time when this config installed packer,
    --       require("packer") fail. So I need to check whether
    --       it is successed or not.
    -- TODO: Is there any good solution to load packer without error
    --       when it is first time to run this config?
    local is_ok = pcall(require, "packer")
    if not is_ok then
        return
    end

    require("packer").startup({
        function(use)
            use("wbthomason/packer.nvim")

            -- Syntax highlight
            use{
                "nvim-treesitter/nvim-treesitter",
                run = function()
                    require("nvim-treesitter.install").update{
                        with_sync = true
                    }()
                end,
                config = require("plugin.settings.treesitter")
            }

            -- Visual
            use{
                "sainnhe/sonokai",
                config = require("plugin.settings.sonokai")
            }
        end, 
        config = {
            display = {
                open_fn = require("packer.util").float
            }
        }
    })
end)
