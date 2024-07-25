return {
    "nvim-neorg/neorg",
    ft = "norg",
    cmd = "Neorg",
    version = "*",
    opts = {
        load = {
            ["core.defaults"] = {},
            ["core.dirman"] = {
                config = {
                    workspaces = {
                        notes = "~/notes",
                    },
                },
            },
            ["core.completion"] = {
                config = {
                    engine = "nvim-cmp",
                },
            },
        },
    },
}
