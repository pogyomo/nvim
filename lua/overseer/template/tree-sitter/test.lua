return {
    name = "tree-sitter test",
    builder = function()
        return {
            cmd = { "tree-sitter" },
            args = { "test" },
            cwd = vim.fs.dirname(
                vim.fs.find("grammar.js", { upward = true })[1]
            ),
            components = {
                {
                    "dependencies",
                    task_names = { "tree-sitter generate" },
                },
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
