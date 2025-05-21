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
        ensure_installed = "all",
        sync_install = false,
        auto_install = true,
        path_display = "filename_first",
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        scope = {
          enable = true,
        },
      }
      require("nvim-treesitter.install").prefer_git = true
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
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require "alpha.themes.dashboard"
      dashboard.opts.layout[1].val = 8

      dashboard.section.buttons.val = {
        {
          type = "text",
          val = " ",
          opts = {
            position = "center",
          },
        },
        dashboard.button("f", " Open file", ":lua require('telescope.builtin').find_files()<CR>"),
        dashboard.button("g", " Grep", ":lua require('telescope.builtin').live_grep()<CR>"),
        dashboard.button("b", " Buffers", ":lua require('telescope.builtin').buffers()<CR>"),
        dashboard.button("r", " Recent files", ":lua require('telescope.builtin').oldfiles()<CR>"),
        dashboard.button("h", " Help tags", ":lua require('telescope.builtin').help_tags()<CR>"),
        dashboard.button("o", " Open Oil", ":Oil<CR>"),
      }
      dashboard.opts.layout[3].val = 0
      dashboard.section.footer.opts.hl = "@alpha.footer"
      table.insert(dashboard.config.layout, 5, {
        type = "padding",
        val = 1,
      })
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-python",
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
    {
      "CopilotC-Nvim/CopilotChat.nvim",
      branch = "main",
      cmd = "CopilotChat",
      opts = function()
        local user = vim.env.USER or "User"
        user = user:sub(1, 1):upper() .. user:sub(2)
        return {
          auto_insert_mode = true,
          question_header = "  " .. user .. " ",
          answer_header = "  Copilot ",
          window = {
            width = 0.4,
          },
        }
      end,
      keys = {
        {
          "<c-s>",
          "<CR>",
          ft = "copilot-chat",
          desc = "Submit Prompt",
          remap = true,
        },
        { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
        {
          "<leader>aa",
          function()
            return require("CopilotChat").toggle()
          end,
          desc = "Toggle (CopilotChat)",
          mode = { "n", "v" },
        },
        {
          "<leader>ax",
          function()
            return require("CopilotChat").reset()
          end,
          desc = "Clear (CopilotChat)",
          mode = { "n", "v" },
        },
        {
          "<leader>aq",
          function()
            vim.ui.input({
              prompt = "Quick Chat: ",
            }, function(input)
              if input ~= "" then
                require("CopilotChat").ask(input)
              end
            end)
          end,
          desc = "Quick Chat (CopilotChat)",
          mode = { "n", "v" },
        },
        {
          "<leader>ap",
          function()
            require("CopilotChat").select_prompt()
          end,
          desc = "Prompt Actions (CopilotChat)",
          mode = { "n", "v" },
        },
      },
      config = function(_, opts)
        local chat = require "CopilotChat"

        vim.api.nvim_create_autocmd("BufEnter", {
          pattern = "copilot-chat",
          callback = function()
            vim.opt_local.relativenumber = false
            vim.opt_local.number = false
          end,
        })

        chat.setup(opts)
      end,
    },
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  { "akinsho/toggleterm.nvim", version = "*", config = true },
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
}
