local lackluster = require "lackluster"
local color = lackluster.color

vim.api.nvim_set_hl(0, "TreesitterContext", { ctermbg = 0, bg = color.gray1 })
vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { ctermbg = 0, bg = color.gray1 })
vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { ctermbg = 0, bg = color.gray1 })

require("treesitter-context").setup {
  max_lines = 2,
  multiline_threshold = 1,
  mode = "cursor",
  separator = nil,
}

require("illuminate").configure {}

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
        icon = "",
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
    border = "rounded",
  },
}

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

local neotest_configured = false
local function ensure_neotest()
  if neotest_configured then return end
  neotest_configured = true
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
      expanded = "",
      child_prefix = "",
      child_indent = "",
      final_child_prefix = "",
      non_collapsible = "",
      collapsed = "",
      passed = "󰇳 ",
      failed = "󰇴 ",
      running = "",
      unknown = "󱚝 ",
    },
  }
end

vim.keymap.set("n", "<leader>tt", function() ensure_neotest(); require("neotest").run.run(vim.fn.expand "%") end, { desc = "Run File" })
vim.keymap.set("n", "<leader>tT", function() ensure_neotest(); require("neotest").run.run(vim.uv.cwd()) end, { desc = "Run All Test Files" })
vim.keymap.set("n", "<leader>tr", function() ensure_neotest(); require("neotest").run.run() end, { desc = "Run Nearest" })
vim.keymap.set("n", "<leader>tl", function() ensure_neotest(); require("neotest").run.run_last() end, { desc = "Run Last" })
vim.keymap.set("n", "<leader>ts", function() ensure_neotest(); require("neotest").summary.toggle() end, { desc = "Toggle Summary" })
vim.keymap.set("n", "<leader>to", function() ensure_neotest(); require("neotest").output.open { enter = true, auto_close = true } end, { desc = "Show Output" })
vim.keymap.set("n", "<leader>tO", function() ensure_neotest(); require("neotest").output_panel.toggle() end, { desc = "Toggle Output Panel" })
vim.keymap.set("n", "<leader>tS", function() ensure_neotest(); require("neotest").run.stop() end, { desc = "Stop" })
vim.keymap.set("n", "<leader>tw", function() ensure_neotest(); require("neotest").watch.toggle(vim.fn.expand "%") end, { desc = "Toggle Watch" })
vim.keymap.set("n", "<leader>ti", function() ensure_neotest(); require("neotest").run.run({ jestCommand = "INTEGRATION=1 jest" }) end, { desc = "Integrations test" })

local edgy = require "edgy"
vim.opt.splitkeep = "screen"

vim.keymap.set("n", "<leader>el", function() edgy.toggle "left" end, { desc = "Toggle left sidebar" })
vim.keymap.set("n", "<leader>er", function() edgy.toggle "right" end, { desc = "Toggle right sidebar" })

require("edgy").setup {
  options = {
    left = { size = 35 },
    right = { size = 35 },
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
}

require("trouble").setup {}
vim.keymap.set("n", "<leader>tm", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    require("trouble").refresh()
  end,
})

local diff = require "mini.diff"
diff.setup {
  source = diff.gen_source.none(),
}

require("diffview").setup {
  enhanced_diff_hl = true,
  view = {
    merge_tool = {
      layout = "diff3_mixed",
    },
  },
}
vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewOpen<cr>", { desc = "Diffview Open" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File History" })
vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "Branch History" })
vim.keymap.set("n", "<leader>gx", "<cmd>DiffviewClose<cr>", { desc = "Diffview Close" })

require("toggleterm").setup { size = 10, open_mapping = [[<c-\>]] }

require("ibl").setup {
  whitespace = {
    remove_blankline_trail = false,
  },
  indent = {
    highlight = { "WhiteSpace" },
    char = "┊",
  },
  scope = {
    enabled = false,
    show_start = false,
    show_end = false,
    char = "│",
  },
}

require("obsidian").setup {
  workspaces = {
    {
      name = "personal",
      path = "~/notes",
    },
  },
  legacy_commands = false,
}

vim.g.mkdp_filetypes = { "markdown" }

require("noice").setup {}

require("sidekick").setup {
  cli = {
    tools = {
      claude = { cmd = { "claude" } }
    }
  }
}
vim.keymap.set("n", "<leader>ac", function()
  require("sidekick.cli").toggle({ name = "claude", focus = true })
end, { desc = "Sidekick Toggle Claude" })
vim.keymap.set("n", "<leader>aC", function()
  require("sidekick.cli").select()
end, { desc = "Sidekick Select CLI Tool" })
