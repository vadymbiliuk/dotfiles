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
      -- local color = require("lackluster").color
      lackluster.setup {
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
        tweak_syntax = {
          comment = lackluster.color.gray4,
        },
        -- Normal background
        -- tweak_background = {
        --   normal = color.gray1,
        --   menu = color.gray1,
        --   popup = color.gray1,
        -- },

        -- Transparent background.
        tweak_background = {
          normal = "none",
          telescope = "none",
          snacks = "none",
          menu = "none",
          popup = "none",
        },
      }

      vim.cmd.colorscheme "lackluster-dark"
      -- Transparent background extension.
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
