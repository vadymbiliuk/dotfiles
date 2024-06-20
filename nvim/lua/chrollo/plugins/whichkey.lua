return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    local wk = require("which-key")
    wk.setup {
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
      },
      ignore_missing = true,
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
      triggers = "auto",
    }

    wk.register({
      ['<leader>'] = {
        ['o'] = { "<cmd>Oil<cr>", "Open Oil" },
        ['c'] = {
          name = 'Copilot chat',
          ['o'] = { "<cmd>CopilotChatOpen<cr>", "Open chat" },
          ['s'] = { "<cmd>CopilotChatSave<cr>", "Save chat" },
          ['l'] = { "<cmd>CopilotChatLoa<cr>", "Load chat" },
          ['q'] = { "<cmd>CopilotChatClose<cr>", "Close chat" },
        },
        ['g'] = {
          name = 'Git',
          ['g'] = { "<cmd>Neogit<cr>", "Neogit" },
          ['d'] = { "<cmd>DiffviewOpen<cr>", "Diffview" },
          ['D'] = { "<cmd>DiffviewOpen master<cr>", "Diffview" },
          ['L'] = { "<cmd>Neogit log<cr>", "Neogit log" },
          ['p'] = { "<cmd>Neogit push<cr>", "Neogit push" },
        },
        ['w'] = { "<cmd>write<cr>", "Write File" },
      },
    })
  end
}
