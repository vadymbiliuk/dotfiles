local function has_biome_config()
  local uv = vim.loop
  local cwd = uv.cwd()
  local biome_path = cwd .. "/biome.json"
  local stat = uv.fs_stat(biome_path)
  return stat ~= nil
end

return {
  {
    "nvimdev/lspsaga.nvim",
    config = function()
      require("lspsaga").setup {
        lightbulb = { enable = false },
        symbol_in_winbar = { enable = false },
      }
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
  },
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup {
        notify_on_error = true,
        format_on_save = {
          timeout_ms = 500,
          lsp_format = "fallback",
        },
        formatters_by_ft = {
          lua = { "stylua" },
          rust = { "rustfmt" },
          c = { "clang-format" },
          cpp = { "clang-format" },
          python = { "ruff format" },
          markdown = { "prettierd", "prettier" },
          javascript = has_biome_config() and { "biome" } or { "prettierd", "eslint_d" },
          javascriptreact = has_biome_config() and { "biome" } or { "prettierd", "eslint_d" },
          typescript = has_biome_config() and { "biome" } or { "prettierd", "eslint_d" },
          typescriptreact = has_biome_config() and { "biome" } or { "prettierd", "eslint_d" },
          json = has_biome_config() and { "biome" } or { "prettierd" },
          yaml = { "yamlfmt" },
          graphql = { "prettierd" },
          recript = { "rescript" },
          ocaml = { "ocamlformat" },
          prisma = { "prisma format" },
          nix = { "nixfmt" },
          haskell = { "fourmolu", "stylish-haskell" },
          cabal = { "cabal-fmt --inplace" },
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "yioneko/nvim-vtsls" },
    },
    config = function()
      local lspconfig = require "lspconfig"
      local lsp_util = require "lspconfig.util"

      local lsp_servers = {
        "vtsls",
        "bashls",
        "dockerls",
        "pyright",
        "ruff",
        "vimls",
        "yamlls",
        "vuels",
        "svelte",
        "graphql",
        "rust_analyzer",
        "jsonls",
        "lua_ls",
        "nil_ls",
        "biome",
        "tailwindcss",
        "ocamllsp",
        "grammarly",
        "hls",
        "eslint",
      }

      require("vtsls").config {}

      local lsp_servers_custom = {
        tailwindcss = {
          root_dir = function(fname)
            return lsp_util.root_pattern("tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs")(fname)
          end,
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  -- clsx, cn
                  -- https://github.com/tailwindlabs/tailwindcss-intellisense/issues/682#issuecomment-1364585313
                  { [[clsx\(([^)]*)\)]], [["([^"]*)"]] },
                  { [[cn\(([^)]*)\)]], [["([^"]*)"]] },
                  -- Tailwind Variants
                  -- https://www.tailwind-variants.org/docs/getting-started#intellisense-setup-optional
                  { [[tv\(([^)]*)\)]], [==[["'`]([^"'`]*).*?["'`]]==] },
                },
              },
            },
          },
        },
        pyright = {
          settings = {
            pyright = {
              -- Using Ruff's import organizer
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                ignore = { "*" },
              },
            },
          },
        },
        ruff = {
          init_options = {
            settings = {
              args = {},
            },
          },
        },
        lua_ls = {
          single_file_support = true,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              misc = {
                parameters = {},
              },
              hover = { expandAlias = false },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              doc = {
                privateName = { "^_" },
              },
              type = {
                castNumberToInteger = true,
              },
              diagnostics = {
                disable = { "incomplete-signature-doc", "trailing-space" },
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
                groupFileStatus = {
                  ["ambiguity"] = "Opened",
                  ["await"] = "Opened",
                  ["codestyle"] = "None",
                  ["duplicate"] = "Opened",
                  ["global"] = "Opened",
                  ["luadoc"] = "Opened",
                  ["redefined"] = "Opened",
                  ["strict"] = "Opened",
                  ["strong"] = "Opened",
                  ["type-check"] = "Opened",
                  ["unbalanced"] = "Opened",
                  ["unused"] = "Opened",
                },
                unusedLocalExclude = { "_*" },
              },
              format = {
                enable = true,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            },
          },
        },
      }

      -- on attach function
      local on_attach = function(client, bufnr)
        local function buf_set_keymap(...)
          vim.api.nvim_buf_set_keymap(bufnr, ...)
        end
        local opts = { noremap = true, silent = true }
        buf_set_keymap("n", "g]", "<cmd>:Lspsaga diagnostic_jump_next<CR>", opts)
        buf_set_keymap("n", "g[", "<cmd>:Lspsaga diagnostic_jump_next<CR>", opts)
        buf_set_keymap("n", "<leader>ga", "<cmd>:Lspsaga code_action<CR>", opts)
        buf_set_keymap("v", "<leader>ga", "<cmd>:Lspsaga code_action<CR>", opts)
        buf_set_keymap("v", "K", "<cmd>:Lspsaga hover_doc<CR>", opts)
      end

      -- LSP settings (for overriding per client)
      local handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
          border = "rounded",
        }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
          border = "rounded",
        }),
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- optimizes cpu usage source https://github.com/neovim/neovim/issues/23291
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

      local defaults = {
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
        end,
        capabilities = capabilities,
        handlers = handlers,
      }

      local opts = {}
      local capabilities

      for _, server in pairs(lsp_servers) do
        opts = defaults
        server = vim.split(server, "@")[1]

        if lsp_servers_custom[server] then
          opts = vim.tbl_extend("force", opts, lsp_servers_custom[server])
        end

        opts.capabilities = require("blink.cmp").get_lsp_capabilities(opts.capabilities)
        lspconfig[server].setup(opts)
        ::continue::
      end

      local signs = {
        Error = "󰇴 ",
        Warn = "󱚝 ",
        Info = "󰇳 ",
        Hint = "󱜙 ",
      }

      vim.diagnostic.config {
        virtual_text = false,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = signs.Error,
            [vim.diagnostic.severity.WARN] = signs.Warn,
            [vim.diagnostic.severity.INFO] = signs.Info,
            [vim.diagnostic.severity.HINT] = signs.Hint,
          },
        },
        underline = true,
      }

      local ns = vim.api.nvim_create_namespace "my_namespace"
      local orig_signs_handler = vim.diagnostic.handlers.signs
      vim.diagnostic.handlers.signs = {
        show = function(_, bufnr, _, opts)
          -- Get all diagnostics from the whole buffer rather than just the
          -- diagnostics passed to the handler
          local diagnostics = vim.diagnostic.get(bufnr)
          -- Find the "worst" diagnostic per line
          local max_severity_per_line = {}
          for _, d in pairs(diagnostics) do
            local m = max_severity_per_line[d.lnum]
            if not m or d.severity < m.severity then
              max_severity_per_line[d.lnum] = d
            end
          end
          -- Pass the filtered diagnostics (with our custom namespace) to
          -- the original handler
          local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
          orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
        end,
        hide = function(_, bufnr)
          orig_signs_handler.hide(ns, bufnr)
        end,
      }

      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
        callback = function()
          vim.diagnostic.open_float(nil, { focus = false })
        end,
      })

      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "Re-enable autoformat-on-save",
      })
    end,
  },
}
