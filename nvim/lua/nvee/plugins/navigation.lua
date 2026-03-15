return {
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
      },
    },
  },
  {
    "dmtrKovalenko/fff.nvim",
    build = "nix run .#release",
    opts = {
      prompt = " ",
      layout = {
        prompt_position = "top",
      },
    },
    keys = {
      {
        "ff",
        function()
          require("fff").find_files()
        end,
        desc = "Open file picker",
      },
      {
        "<leader>fg",
        function()
          require("fff").live_grep()
        end,
        desc = "Live grep",
      },
    },
  },
  { "mg979/vim-visual-multi" },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon add file" })
      vim.keymap.set("n", "<leader>d", function() harpoon:list():remove() end, { desc = "Harpoon remove file" })
      vim.keymap.set("n", "<C-e>", function()
        harpoon.ui:toggle_quick_menu(harpoon:list(), { border = "rounded" })
      end, { desc = "Harpoon menu" })

      vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
      vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
      vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
      vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })

      vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Harpoon prev" })
      vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Harpoon next" })
    end,
  },
}
