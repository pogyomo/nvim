return {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        -- Snippet engine
        "L3MON4D3/LuaSnip",

        -- Snippents
        { "pogyomo/cppguard.nvim", dev = true },

        -- Sources
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",

        -- Visual
        "onsails/lspkind.nvim",
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        luasnip.add_snippets("cpp", {
            require("cppguard").snippet_luasnip("guard"),
        })

        -- Settings for insert mode.
        cmp.setup {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            window = {
                completion = {
                    winblend = 10,
                },
                documentation = {
                    winblend = 10,
                    border = "rounded",
                },
            },
            formatting = {
                fields = { "kind", "abbr" },
                format = require("lspkind").cmp_format {
                    mode = "symbol",
                },
            },
            mapping = {
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<CR>"] = cmp.mapping.confirm { select = false },
                ["<C-n>"] = cmp.mapping.select_next_item {
                    behavior = cmp.SelectBehavior.Select,
                },
                ["<C-p>"] = cmp.mapping.select_prev_item {
                    behavior = cmp.SelectBehavior.Select,
                },
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
            },
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "lazydev" },
            }, {
                { name = "buffer" },
                { name = "path" },
            }),
        }

        -- Command line settings (when "/" or "?")
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })

        -- Command line settings (when ":")
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                { name = "cmdline" },
            }),
        })
    end,
}
