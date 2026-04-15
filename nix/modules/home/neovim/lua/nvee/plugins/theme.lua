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
    Cursor = {
      overwrite = true,
      bg = lackluster.color.gray9,
      fg = lackluster.color.black,
    },
    TermCursor = {
      overwrite = true,
      bg = lackluster.color.gray9,
      fg = lackluster.color.gray1,
    },
    TermCursorNC = {
      overwrite = true,
      bg = lackluster.color.gray9,
      fg = lackluster.color.gray1,
    },
    Search = {
      overwrite = true,
      bg = lackluster.color.gray8,
      fg = lackluster.color.gray1,
    },
    CurSearch = {
      overwrite = true,
      bg = lackluster.color.gray9,
      fg = lackluster.color.gray1,
    },
    IncSearch = {
      overwrite = true,
      bg = lackluster.color.gray9,
      fg = lackluster.color.gray1,
    },
    Substitute = {
      overwrite = true,
      bg = lackluster.color.gray9,
      fg = lackluster.color.gray1,
    },
    Visual = {
      overwrite = true,
      bg = lackluster.color.gray7,
      fg = lackluster.color.black,
    },
    VisualCursor = {
      overwrite = true,
      bg = lackluster.color.gray9,
      fg = lackluster.color.black,
    },
    ["@string.special.symbol.ruby"] = {
      overwrite = true,
      fg = lackluster.color.gray9,
    },
    ["@symbol.ruby"] = {
      overwrite = true,
      fg = lackluster.color.gray9,
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

vim.schedule(function()
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#3c4048", bg = "none" })
  vim.api.nvim_set_hl(0, "TroubleNormal", { bg = "none", ctermbg = "none" })
  vim.api.nvim_set_hl(0, "TroubleNormalNC", { bg = "none", ctermbg = "none" })
  vim.api.nvim_set_hl(0, "SnacksNormal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "SnacksNormalNC", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "TelescopeMatching", { bg = lackluster.color.gray9, fg = lackluster.color.gray1 })
  vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = lackluster.color.gray8, fg = lackluster.color.gray9 })
  vim.api.nvim_set_hl(0, "MatchParen", { bg = lackluster.color.gray8, fg = lackluster.color.gray9 })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = lackluster.color.gray2 })
  vim.api.nvim_set_hl(0, "CursorLineNr", { bg = lackluster.color.gray2, fg = lackluster.color.gray8 })
  vim.api.nvim_set_hl(0, "LineNr", { fg = lackluster.color.gray4 })
  vim.api.nvim_set_hl(0, "LspReferenceText", { bg = lackluster.color.gray9, fg = lackluster.color.gray1 })
  vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = lackluster.color.gray9, fg = lackluster.color.gray1 })
  vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = lackluster.color.gray9, fg = lackluster.color.gray1 })
  vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = lackluster.color.gray6, fg = lackluster.color.black })
  vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = lackluster.color.gray6, fg = lackluster.color.black })
  vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = lackluster.color.gray6, fg = lackluster.color.black })

  vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#2a3a2a", fg = lackluster.color.gray9 })
  vim.api.nvim_set_hl(0, "DiffChange", { bg = "#2a2a3a", fg = lackluster.color.gray9 })
  vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#3a2a2a", fg = lackluster.color.gray5 })
  vim.api.nvim_set_hl(0, "DiffText", { bg = "#3a3a5a", fg = lackluster.color.gray9, bold = true })


  vim.opt.termguicolors = true
  vim.opt.guicursor =
    "n-c-sm:block-Cursor/lCursor,v:block-VisualCursor/lCursor,i-ci-ve:ver25-Cursor/lCursor,r-cr-o:hor20-Cursor/lCursor"
end)
