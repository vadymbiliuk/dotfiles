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
    build = function()
      require("fff.download").download_or_build_binary()
    end,
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
    },
  },
  { "mg979/vim-visual-multi" },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  },
}
