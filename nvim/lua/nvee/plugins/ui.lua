return {
  { "nvim-tree/nvim-web-devicons" },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      local color = require("lackluster").color

      vim.api.nvim_set_hl(0, "TreesitterContext", {
        ctermbg = 0,
        bg = color.gray1,
      })
      vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", {
        ctermbg = 0,
        bg = color.gray1,
      })
      vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", {
        ctermbg = 0,
        bg = color.gray1,
      })

      require("treesitter-context").setup {
        max_lines = 2,
        multiline_threshold = 1,
        mode = "cursor",
        separator = nil,
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {},
        sync_install = false,
        auto_install = false,
        path_display = "filename_first",
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        scope = {
          enable = true,
        },
      }
    end,
  },
  {
    "RRethy/vim-illuminate",
    version = "*",
    config = function()
      require("illuminate").configure {}
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local lackluster = require "lackluster"
      require("lualine").setup {
        options = {
          theme = "lackluster",
          icons_enabled = false,
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { { "filename", path = 1 } },
          lualine_c = {},
          lualine_x = {},
          lualine_y = {
            "searchcount",
            "selectioncount",
            "diagnostics",
            { "branch", color = { fg = lackluster.color.gray6 } },
            "branch",
            "diff",
          },
          lualine_z = {
            {
              "lsp_status",
              icon = "",
              symbols = {
                spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
                done = "",
                separator = " ",
              },
              ignore_lsp = {},
            },
          },
        },
      }
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      require("gitsigns").setup {
        attach_to_untracked = true,
        signs = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "•" },
          topdelete = { text = "•" },
          changedelete = { text = "•" },
          untracked = { text = "┃" },
        },
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 50,
          ignore_whitespace = false,
          virt_text_priority = 100,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        signs_staged = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "•" },
          topdelete = { text = "•" },
          changedelete = { text = "•" },
          untracked = { text = "┃" },
        },
        sign_priority = 0,
        preview_config = {
          border = BORDER_STYLE,
        },
      }
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    priority = 100,
    config = function()
      local builtin = require "statuscol.builtin"

      require("statuscol").setup {
        relculright = true,
        segments = {
          {
            sign = {
              namespace = { "gitsigns" },
              maxwidth = 1,
              colwidth = 1,
              auto = false,
              fillchar = " ",
              fillcharhl = " ",
            },
            click = "v:lua.ScSa",
          },
          {
            sign = {
              namespace = { "diagnostic" },
              name = { "neotest_" },
              auto = false,
              wrap = true,
              fillchar = " ",
              fillcharhl = " ",
            },
            click = "v:lua.ScSa",
            condition = {
              function(args)
                return args.sclnu
              end,
            },
          },
          { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
          { text = { builtin.foldfunc, " " }, click = "v:luaScFa" },
        },
      }
    end,
  },
  { "aznhe21/actions-preview.nvim" },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-python",
      "olimorris/neotest-rspec",
    },
    keys = {
      {
        "<leader>t",
        "",
        desc = "+test",
      },
      {
        "<leader>tt",
        function()
          require("neotest").run.run(vim.fn.expand "%")
        end,
        desc = "Run File",
      },
      {
        "<leader>tT",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "Run All Test Files",
      },
      {
        "<leader>tr",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open { enter = true, auto_close = true }
        end,
        desc = "Show Output",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Output Panel",
      },
      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop",
      },
      {
        "<leader>tw",
        function()
          require("neotest").watch.toggle(vim.fn.expand "%")
        end,
        desc = "Toggle Watch",
      },
      {
        "<leader>ti",
        "<cmd>lua require('neotest').run.run({ jestCommand = 'INTEGRATION=1 jest' })<cr>",
        desc = "Toggle Watch",
      },
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-jest" {
            jestCommand = "npm run test:js --",
            jestConfigFile = "jest.config.ts",
            env = { CI = true },
            cwd = function()
              return vim.fn.getcwd()
            end,
          },
          require "neotest-vitest",
          require "neotest-python" {
            dap = { justMyCode = false },
          },
          require "neotest-rspec" {
            command = "bundle exec rspec",
            root_files = { "Gemfile", ".rspec", ".gitignore" },
            filter_dirs = { "vendor", "node_modules" },
          },
        },
        icons = {
          expanded = "",
          child_prefix = "",
          child_indent = "",
          final_child_prefix = "",
          non_collapsible = "",
          collapsed = "",

          passed = "󰇳 ",
          failed = "󰇴 ",
          running = "",
          unknown = "󱚝 ",
        },
      }
    end,
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
      local edgy = require "edgy"
      vim.opt.splitkeep = "screen"

      vim.keymap.set("n", "<leader>el", function()
        edgy.toggle "left"
      end, { desc = "Toggle left sidebar" })
      vim.keymap.set("n", "<leader>er", function()
        edgy.toggle "right"
      end, { desc = "Toggle right sidebar" })
    end,
    dependencies = {
      {
        "nvim-neotest/neotest",
        "nvim-neotest/neotest-jest",
        "nvim-neotest/neotest-python",
      },
      {
        "folke/trouble.nvim",
        branch = "main",
        keys = {
          {
            "<leader>tm",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
          },
          {
            "<leader>ts",
            "<cmd>Trouble symbols toggle<cr>",
            desc = "Symbols (Trouble)",
          },
        },
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        init = function()
          vim.api.nvim_create_autocmd("BufReadPost", {
            pattern = "*",
            callback = function()
              require("trouble").refresh()
            end,
          })
        end,
      },
    },
    opts = {
      options = {
        left = {
          size = 35,
        },
        right = {
          size = 35,
        },
      },
      close_when_all_hidden = true,
      right = {
        {
          ft = "Neotest",
          pinned = true,
          title = "Test",
          open = "Neotest summary",
          size = { height = 0.5 },
        },
      },
      left = {

        -- Neo-tree filesystem always takes half the screen height
        {
          ft = "trouble",
          pinned = true,
          title = "Sidebar",
          filter = function(_buf, win)
            return vim.w[win].trouble.mode == "symbols"
          end,
          open = "Trouble symbols position=left focus=false filter.buf=0",
          size = { height = 0.6 },
        },
        {
          ft = "trouble",
          pinned = true,
          title = "Troubles",
          filter = function(_buf, win)
            return vim.w[win].trouble.mode == "diagnostics"
          end,
          open = "Trouble diagnostics focus=false filter.severity=vim.diagnostic.severity.ERROR",
          size = { height = 0.4 },
        },
      },
    },
  },
  {
    "echasnovski/mini.diff",
    config = function()
      local diff = require "mini.diff"
      diff.setup {
        source = diff.gen_source.none(),
      }
    end,
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
      { "<leader>gx", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        merge_tool = {
          layout = "diff3_mixed",
        },
      },
    },
  },
  { "akinsho/toggleterm.nvim", version = "*", opts = { size = 10, open_mapping = [[<c-\>]] } },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      whitespace = {
        remove_blankline_trail = false,
      },
      indent = {
        highlight = {
          "WhiteSpace",
        },
        char = "┊",
      },
      scope = {
        enabled = false,
        show_start = false,
        show_end = false,
        char = "│",
      },
    },
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/notes",
        },
      },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        tools = {
          claude = { cmd = { "claude" } }
        }
      }
    },
    keys = {
      {
        "<leader>ac",
        function() 
          require("sidekick.cli").toggle({ 
            name = "claude", 
            focus = true 
          }) 
        end,
        desc = "Sidekick Toggle Claude"
      },
      {
        "<leader>aC",
        function() 
          require("sidekick.cli").select()
        end,
        desc = "Sidekick Select CLI Tool"
      }
    }
  },
}
