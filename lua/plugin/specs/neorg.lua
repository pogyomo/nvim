return {
    "nvim-neorg/neorg",
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
