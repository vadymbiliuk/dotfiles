return {
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-lua/plenary.nvim",
      "psiska/telescope-hoogle.nvim",
    },
    config = function()
      require("telescope").setup {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          layout_config = {
            prompt_position = "bottom",
            horizontal = {
              mirror = false,
              preview_cutoff = 100,
              preview_width = 0.5,
            },
          },
        },
        pickers = {
          oldfiles = {
            cwd_only = true,
          },
          find_files = {
            hidden = true,
          },
        },
        extensions = {
          hoogle = {
            render = "default",
            renders = {
              treesitter = {
                remove_wrap = false,
              },
            },
          },
        },
      }
      require("telescope").load_extension "fzf"
    end,
  },
  { "mg979/vim-visual-multi" },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  },
}
