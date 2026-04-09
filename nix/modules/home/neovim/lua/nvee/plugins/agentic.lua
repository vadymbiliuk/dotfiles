require("claudecode").setup()

vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<CR>", { desc = "Toggle Claude Code" })
vim.keymap.set("n", "<leader>cf", "<cmd>ClaudeCodeFocus<CR>", { desc = "Focus Claude Code" })
vim.keymap.set("n", "<leader>cr", "<cmd>ClaudeCodeResume<CR>", { desc = "Resume Claude Code" })
vim.keymap.set("n", "<leader>cC", "<cmd>ClaudeCodeContinue<CR>", { desc = "Continue Claude Code" })
vim.keymap.set("v", "<leader>cs", "<cmd>ClaudeCodeSend<CR>", { desc = "Send selection to Claude" })
vim.keymap.set("n", "<leader>cb", "<cmd>ClaudeCodeAdd %<CR>", { desc = "Add buffer to Claude" })
vim.keymap.set("n", "<leader>ca", "<cmd>ClaudeCodeDiffAccept<CR>", { desc = "Accept Claude diff" })
vim.keymap.set("n", "<leader>cd", "<cmd>ClaudeCodeDiffDeny<CR>", { desc = "Deny Claude diff" })

vim.g.copilot_settings = { selectedCompletionModel = "gpt-41-copilot" }
vim.g.copilot_integration_id = "vscode-chat"
