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
          ['l'] = { "<cmd>Neogit log<cr>", "Neogit log" },
          ['p'] = { "<cmd>Neogit push<cr>", "Neogit push" },
        },
        ['f'] = {
          name = 'Telescope',
          ['f'] = { "<cmd>Telescope find_files<cr>", "Find File" },
          ['r'] = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap = false },
          ['g'] = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
          ['b'] = { "<cmd>Telescope git_branches<cr>", "Checkout Branch" },
          ['c'] = { "<cmd>Telescope git_commits<cr>", "Checkout Commit" },
          ['s'] = { "<cmd>Telescope git_status<cr>", "Git Status" },
          ['h'] = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
          ['p'] = { "<cmd>Telescope projects<cr>", "Projects" },
          ['m'] = { "<cmd>Telescope media_files<cr>", "Media Files" },
          ['t'] = { "<cmd>Telescope treesitter<cr>", "Treesitter" },
        },
        ['w'] = { "<cmd>write<cr>", "Write File" },
      },
      ['<space>'] = {
        ['e'] = { "<cmd>NvimTreeToggle<cr>", "Toggle File Explorer" },
      },
    })
  end
}
