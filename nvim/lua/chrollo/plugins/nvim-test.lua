return {
    "klen/nvim-test",
    config = function()
        require('nvim-test').setup()

        require('nvim-test.runners.pytest'):setup {
            command = ".venv/bin/pytest", -- a command to run the test runner
        }
    end
}
