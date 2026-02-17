return {
  { "tpope/vim-sleuth" },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   config = function()
  --     require("copilot").setup {
  --       suggestion = { enabled = false },
  --       panel = { enabled = false },
  --     }
  --   end,
  -- },
  {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = {
      "rafamadriz/friendly-snippets",
      "giuxtaposition/blink-cmp-copilot",
    },
    version = "v0.*",
    config = function()
      -- require("copilot").setup {
      --   enabled = false,
      --   suggestion = { enabled = false },
      --   panel = { enabled = false },
      -- }
      require("blink.cmp").setup {
        completion = {
          menu = { border = "rounded" },
          documentation = { window = { border = "rounded" } },
        },
        signature = { enabled = true, window = { border = "rounded" } },
        fuzzy = {
          implementation = "rust",
          use_frecency = true,
          use_unsafe_no_lock = false,
          sorts = {
            -- (optionally) always prioritize exact matches
            "exact",
            "score",
            "sort_text",
          },
        },
        cmdline = {
          completion = {
            ghost_text = { enabled = true },
            menu = {
              auto_show = function(ctx)
                return vim.fn.getcmdtype() == ":"
                -- enable for inputs as well, with:
                -- or vim.fn.getcmdtype() == '@'
              end,
            },
          },
        },
        keymap = {
          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
          ["<C-e>"] = { "hide" },
          ["<C-y>"] = { "select_and_accept" },
          ["<Up>"] = { "select_prev", "fallback" },
          ["<Down>"] = { "select_next", "fallback" },
          ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
          ["<C-n>"] = { "select_next", "fallback_to_mappings" },

          ["<C-b>"] = { "scroll_documentation_up", "fallback" },
          ["<C-f>"] = { "scroll_documentation_down", "fallback" },

          ["<Tab>"] = { "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "snippet_backward", "fallback" },

          ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
          ["<CR>"] = { "accept", "fallback" },
        },
        sources = {
          -- default = { "lsp", "path", "snippets", "buffer", "copilot" },
          default = { "lsp", "path", "snippets", "buffer" },
          per_filetype = {
            codecompanion = { "codecompanion" },
          },
          providers = {
            copilot = {
              name = "copilot",
              module = "blink-cmp-copilot",
              score_offset = 100,
              async = true,
            },
          },
        },
      }
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
      require("flash").setup {
        modes = {
          search = {
            enabled = true,
          },
        },
      }
      
      local lackluster = require("lackluster")
      vim.api.nvim_set_hl(0, "FlashLabel", { bg = lackluster.color.gray8, fg = lackluster.color.gray1 })
      vim.api.nvim_set_hl(0, "FlashMatch", { bg = lackluster.color.gray9, fg = lackluster.color.gray1 })
      vim.api.nvim_set_hl(0, "FlashCurrent", { bg = lackluster.color.gray8, fg = lackluster.color.gray1 })
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "^3.0.0",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {}
    end,
  },
  {
    "echasnovski/mini.move",
    version = "*",
    opts = {
      mappings = {
        left = "<C-h>",
        right = "<C-l>",
        down = "<C-j>",
        up = "<C-k>",

        line_left = "<C-h>",
        line_right = "<C-l>",
        line_down = "<C-j>",
        line_up = "<C-k>",
      },

      options = {
        reindent_linewise = true,
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "windwp/nvim-ts-autotag",
    config = true,
  },
  {
    "nvim-pack/nvim-spectre",
    config = function()
      require("spectre").setup {
        default = {
          replace = {
            cmd = "sed",
          },
        },
      }

      vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
        desc = "Toggle Spectre",
      })
      vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
        desc = "Search current word",
      })
      vim.keymap.set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
        desc = "Search current word",
      })
      vim.keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
        desc = "Search on current file",
      })
    end,
  },
  { "numToStr/Comment.nvim" },
}
