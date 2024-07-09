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
    init = function()
      local lackluster = require("lackluster")
      lackluster.setup({
        tweak_background = {
          popup = '#101010',
        },
      })
      vim.cmd.colorscheme("lackluster")
    end,
  }
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
