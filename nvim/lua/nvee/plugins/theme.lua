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
          string = accent,
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
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    opts = {},
  },
}
