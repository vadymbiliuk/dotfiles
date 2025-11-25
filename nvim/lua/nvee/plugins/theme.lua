return {
  {
    "slugbyte/lackluster.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      local lackluster = require "lackluster"
      require("nvim-web-devicons").setup {
        color_icons = false,
        override = {
          ["default_icon"] = {
            color = lackluster.color.gray4,
            name = "Default",
          },
        },
      }
      local accent = "#F3669E"
      lackluster.setup {
        tweak_syntax = {
          string = lackluster.color.gray9,
          comment = lackluster.color.gray4,
        },
        tweak_highlight = {
          ["@keyword"] = {
            bold = true,
            italic = false,
          },
          ["@function"] = {
            link = "@keyword",
          },
          FloatBorder = {
            overwrite = true,
            fg = lackluster.color.gray6,
            bg = "NONE",
          },
        },
        tweak_background = {
          normal = "none",
          telescope = "none",
          snacks = "none",
          menu = "none",
          popup = "none",
        },
      }

      vim.cmd.colorscheme "lackluster"

      vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#3c4048", bg = "none" })
      vim.api.nvim_set_hl(0, "TroubleNormal", { bg = "none", ctermbg = "none" })
      vim.api.nvim_set_hl(0, "TroubleNormalNC", { bg = "none", ctermbg = "none" })
      vim.api.nvim_set_hl(0, "TroubleNormal", { bg = "none", ctermbg = "none" })
      vim.api.nvim_set_hl(0, "TroubleNormalNC", { bg = "none", ctermbg = "none" })
      vim.api.nvim_set_hl(0, "SnacksNormal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "SnacksNormalNC", { bg = "NONE" })
    end,
  },
  -- {
  --   "amedoeyes/eyes.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     transparent = true,
  --     highlights = {
  --       core = "all",
  --       plugins = (package.loaded.lazy or package.loaded["mini.deps"]) and "auto" or "all",
  --     },
  --     extend = {
  --       highlights = {},
  --       palette = {},
  --     },
  --   },
  --   init = function()
  --     vim.cmd.colorscheme "eyes"
  --   end,
  -- },
  -- {
  --   "xiyaowong/transparent.nvim",
  --   lazy = false,
  --   opts = {},
  -- },
}
