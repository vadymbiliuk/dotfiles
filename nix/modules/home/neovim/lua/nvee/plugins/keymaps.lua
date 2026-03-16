require("which-key").setup {}

vim.keymap.set("n", "<leader>?", function()
  require("which-key").show { global = false }
end, { desc = "Buffer Local Keymaps (which-key)" })

vim.keymap.set("n", "<leader>o", "<cmd>Oil<cr>", { desc = "Open Oil" })

vim.keymap.set({ "n", "x", "o" }, "S", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter" })

vim.keymap.set("o", "r", function()
  require("flash").remote()
end, { desc = "Remote Flash" })

vim.keymap.set({ "o", "x" }, "R", function()
  require("flash").treesitter_search()
end, { desc = "Treesitter Search" })

vim.keymap.set("c", "<c-s>", function()
  require("flash").toggle()
end, { desc = "Toggle Flash Search" })
