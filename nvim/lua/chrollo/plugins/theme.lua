return {
  -- {
  --   'projekt0n/github-nvim-theme',
  --   lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     require('github-theme').setup({
  --       -- ...
  --     })
  --
  --     vim.cmd('colorscheme github_dark_dimmed')
  --   end,
  -- },
  {
    "slugbyte/lackluster.nvim",
    lazy = false,
    priority = 1000,
    dev = true,
    init = function()
      local lackluster = require("lackluster")
      lackluster.setup({
        tweak_background = {
          popup = '#101010',
        },
      })

      local make_bold = function(name)
        local value = vim.api.nvim_get_hl(0, { name = name })
        value.bold = true
        vim.api.nvim_set_hl(0, name, value)
      end

      local make_italic = function(name)
        local value = vim.api.nvim_get_hl(0, { name = name })
        value.italic = true
        vim.api.nvim_set_hl(0, name, value)
      end

      local make_bold_italic = function(name)
        local value = vim.api.nvim_get_hl(0, { name = name })
        value.bold = true
        value.italic = true
        vim.api.nvim_set_hl(0, name, value)
      end

      vim.cmd.colorscheme("lackluster")

      make_bold("Bold")
      make_bold("markdownBold")
      make_bold("@function")
      make_bold("@text.strong")
      make_bold("@symbol")
      make_bold("StatusLineDiagnosticWarn")
      make_bold("StatusLineDiagnosticError")
      make_bold("TelescopeMatching")
      make_bold("@lsp.type.function")
      make_bold("@lsp.type.method")

      make_italic("Comment")
      make_italic("markdownItalic")
      make_italic("markdownRule")
      make_italic("@keyword")
      make_italic("@text.emphasis")
      make_italic("@comment")
      make_italic("@lsp.type.comment")
      make_italic("markdownRule")

      make_bold_italic("markdownBoldItalic")
    end,
  },
  -- {
  --   "horanmustaplot/xcarbon.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd("colorscheme xcarbon")
  --   end,
  -- }
  -- {
  --   'arzg/vim-colors-xcode',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd [[colorscheme xcodedark]]
  --   end
  -- },
  -- {
  --   'cvigilv/patana.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     -- require('patana').setup({})
  --
  --     vim.cmd('colorscheme patana')
  --   end
  -- },
  -- {
  --   'jesseleite/nvim-noirbuddy',
  --   dependencies = {
  --     { 'tjdevries/colorbuddy.nvim' }
  --   },
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     -- All of your `setup(opts)` will go here
  --   },
  -- },
  -- {
  --   "nyoom-engineering/oxocarbon.nvim",
  --   priority = 1000,
  --   config = function()
  --     vim.opt.background = "dark" -- set this to dark or light
  --     vim.cmd.colorscheme "oxocarbon"
  --   end
  -- },
  -- {
  --   'lunacookies/vim-colors-xcode',
  --   priority = 1000,
  --   config = function()
  --     vim.cmd [[colorscheme xcodedark]]
  --   end
  -- },
  -- {
  --   "n1ghtmare/noirblaze-vim",
  --   priority = 1000,
  --   config = function()
  --     vim.opt.background = "dark" -- set this to dark or light
  --     vim.cmd.colorscheme "noirblaze"
  --   end
  -- },
  -- {
  --   "alligator/accent.vim",
  --   priority = 1000,
  --   config = function()
  --     vim.cmd [[let g:accent_colour = 'magenta']]
  --     vim.opt.background = "dark" -- set this to dark or light
  --     vim.cmd.colorscheme "accent"
  --   end
  -- }
}
