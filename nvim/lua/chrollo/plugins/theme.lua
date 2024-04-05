return {
  {
    "nyoom-engineering/oxocarbon.nvim",
    priority = 1000,
    config = function()
      vim.opt.background = "dark" -- set this to dark or light
      vim.cmd.colorscheme "oxocarbon"
    end
  },
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
