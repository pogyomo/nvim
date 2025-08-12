return {
    name = "tree-sitter generate",
    builder = function()
        return {
            cmd = { "tree-sitter" },
            args = { "generate" },
            cwd = vim.fs.dirname(
                vim.fs.find("grammar.js", { upward = true })[1]
            ),
            components = {
                {
                    "open_output",
                    focus = true,
                    on_complete = "failure",
                    on_start = "never",
                },
                "default",
            },
        }
    end,
    condition = {
        callback = function()
            return #vim.fs.find("grammar.js", { upward = true }) ~= 0
        end,
    },
}
