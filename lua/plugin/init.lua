require("utils.install.packer").install(function()
    -- NOTE: If it is a time when this config installed packer,
    --       require("packer") fail. So I need to check whether
    --       it is successed or not.
    -- TODO: Is there any good solution to load packer without error
    --       when it is first time to run this config?
    local module = require("utils.module")
    local is_ok, mods = pcall(module.require, {
        "packer"
    })
    if not is_ok then
        return
    end

    mods["packer"].startup({
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
                requires = {
                    {
                        "p00f/nvim-ts-rainbow",
                        cond = function()
                            return pcall(require, "nvim-treesitter")
                        end
                    }
                },
                config = require("plugin.settings.treesitter")
            }

            -- Statusline
            use{
                "nvim-lualine/lualine.nvim",
                requires = {
                    "kyazdani42/nvim-web-devicons"
                },
                config = require("plugin.settings.lualine")
            }

            -- Visual
            use{
                "sainnhe/sonokai",
                config = require("plugin.settings.sonokai")
            }
            use{
                "lukas-reineke/indent-blankline.nvim",
                config = require("plugin.settings.indent")
            }
            use{
                "rcarriga/nvim-notify",
                config = require("plugin.settings.notify")
            }
            use{
                "folke/todo-comments.nvim",
                config = require("plugin.settings.todo")
            }

            -- Key mapping
            use{
                "windwp/nvim-autopairs",
                config = require("plugin.settings.autopairs")
            }
        end, 
        config = {
            display = {
                open_fn = require("packer.util").float
            }
        }
    })
end)
