return {
    "stevearc/overseer.nvim",
    version = "2.*",
    cmd = {
        "OverseerRun",
        "OverseerInfo",
        "OverseerOpen",
        "OverseerBuild",
        "OverseerClose",
        "OverseerRunCmd",
        "OverseerToggle",
        "OverseerClearCache",
        "OverseerLoadBundle",
        "OverseerSaveBundle",
        "OverseerTaskAction",
        "OverseerQuickAction",
        "OverseerDeleteBundle",
    },
    opts = {
        templates = {
            "builtin",
            "tree-sitter.test",
            "tree-sitter.generate",
        },
    },
}
