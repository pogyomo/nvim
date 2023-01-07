require("plugin.install")(function()
    vim.cmd.packadd("packer.nvim")
    require("packer").startup({
        function(use)
            use("wbthomason/packer.nvim")
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
