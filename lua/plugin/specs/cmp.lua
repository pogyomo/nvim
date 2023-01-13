return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        -- Snippet engine
        "L3MON4D3/LuaSnip",

        -- Sources
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "saadparwaiz1/cmp_luasnip",

        -- Visual
        "onsails/lspkind.nvim"
    },
    config = function()
        local module = require("utils.module")
        local mods = module.require{
            "cmp",
            "luasnip",
            "lspkind"
        }

        -- Set the transparency of completion menu.
        vim.opt.pumblend = 10

        -- Settings for insert mode.
        mods["cmp"].setup{
            snippet = {
                expand = function(args)
                    mods["luasnip"].lsp_expand(args.body)
                end
            },
            window = {
                documentation = {
                    border = "rounded"
                }
            },
            formatting = {
                format = mods["lspkind"].cmp_format{
                    mode = "symbol_text",
                    -- List all possible source name
                    menu = {
                        buffer =   "[Buffer]",
                        cmdline =  "[Cmd]",
                        luasnip =  "[LuaSnip]",
                        nvim_lsp = "[LSP]",
                        path =     "[Path]"
                    }
                }
            },
            mapping = {
                ["<Tab>"] = mods["cmp"].mapping.select_next_item(),
                ["<CR>"]  = mods["cmp"].mapping.confirm{ select = false },
                ["<C-n>"] = mods["cmp"].mapping.select_next_item{
                    behavior = mods["cmp"].SelectBehavior.Select
                },
                ["<C-p>"] = mods["cmp"].mapping.select_prev_item{
                    behavior = mods["cmp"].SelectBehavior.Select
                },
                ["<C-b>"] = mods["cmp"].mapping.scroll_docs(-4),
                ["<C-f>"] = mods["cmp"].mapping.scroll_docs(4)
            },
            sources = mods["cmp"].config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "nvim_lsp_signature_help" }
            }, {
                { name = "buffer" },
                { name = "path" }
            })
        }

        -- Command line settings (when "/")
        -- TODO: How can I show the completion menu automatically?
        mods["cmp"].setup.cmdline({ "/", "?" }, {
            mapping = mods["cmp"].mapping.preset.cmdline(),
            sources = {
                { name = "buffer" }
            }
        })

        -- Command line settings (when ":")
        mods["cmp"].setup.cmdline(":", {
            mapping = mods["cmp"].mapping.preset.cmdline(),
            sources = mods["cmp"].config.sources({
                { name = "path" }
            }, {
                { name = "cmdline" }
            })
        })
    end
}