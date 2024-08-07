local BORDER_STYLE = require('chrollo.config.settings').border
local lspconfig = require('lspconfig')
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')

require('lspconfig.ui.windows').default_options.border = BORDER_STYLE

local lsp_servers = {
  -- 'vtsls',
  "bashls",
  "dockerls",
  "pyright",
  "ruff_lsp",
  "vimls",
  "yamlls",
  "vuels",
  "svelte",
  "graphql",
  "rust_analyzer",
  "clangd",
  "intelephense",
  "prismals",
  "texlab",
  "html",
  "cssls",
  "jsonls",
  "grammarly",
  "lua_ls",
  "eslint",
  "nil_ls",
  "biome",
  "tailwindcss"
}

require("typescript-tools").setup({
  on_attach = on_attach,
  handlers = handlers,
  capabilities = capabilities,
  settings = {
    tsserver_file_preferences = {
      includeInlayParameterNameHints = "all",
      includeCompletionsForModuleExports = true,
      quotePreference = "auto",
    },
    tsserver_format_options = {
      allowIncompleteCompletions = false,
      allowRenameOfImportPath = false,
    }
  },
})


local lsp_servers_custom = {
  pyright = {
    settings = {
      pyright = {
        -- Using Ruff's import organizer
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          -- Ignore all files for analysis to exclusively use Ruff for linting
          ignore = { '*' },
        },
      },
    },
  },
  eslint = {
    filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  },
  grammarly = {
    -- Grammarly language server requires node js 16.4 ¯\_(ツ)_/¯
    -- https://github.com/neovim/nvim-lspconfig/issues/2007
    cmd = { "fnm", "use", "16.4", "/Users/vadymbiliuk/.nix-profile/bin/grammarly-languageserver", "--stdio" },
    filetypes = { "markdown", "text", "hgcommit", "gitcommit" },
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
          parameters = {
          },
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

---@enum
local provider = {
  HOVER = 'hoverProvider',
  RENAME = 'renameProvider',
  CODELENS = 'codeLensProvider',
  CODEACTIONS = 'codeActionProvider',
  FORMATTING = 'documentFormattingProvider',
  REFERENCES = 'documentHighlightProvider',
  DEFINITION = 'definitionProvider',
}

-- on attach function
local on_attach = function(client, bufnr)
  -- Keybindings
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap = true, silent = true }
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gw', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  buf_set_keymap('n', 'gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
  buf_set_keymap('n', '<leader>ad', '<cmd>lua vim.lsp.diagnostic.show()<CR>', opts)
  buf_set_keymap('n', '<leader>aD', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua require("actions-preview").code_actions()<CR>', opts)
  buf_set_keymap('v', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
  buf_set_keymap('i', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>ar', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>aI', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
  buf_set_keymap('n', '<leader>aO', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)
  buf_set_keymap('n', '<leader>ee', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<leader>ec', '<cmd>lua vim.lsp.diagnostic.show_position_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<leader>f=', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  buf_set_keymap('n', ']g', '<cmd>lua vim.diagnostic.goto_next({ float = true })<CR>', opts)
  buf_set_keymap('n', '[g', '<cmd>lua vim.diagnostic.goto_prev({ float = true })<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua require("pretty_hover").hover()<CR>', opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion =
    require("cmp_nvim_lsp").default_capabilities(capabilities).textDocument.completion

capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}

-- optimizes cpu usage source https://github.com/neovim/neovim/issues/23291
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

-- LSP settings (for overriding per client)
local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = BORDER_STYLE }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = BORDER_STYLE }),
}

local defaults = {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  handlers = handlers,
}

local settings = {
  ui = {
    border = "rounded",
    icons = {
      package_installed = "◍",
      package_pending = "◍",
      package_uninstalled = "◍",
    },
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
}

mason.setup(settings)
mason_lspconfig.setup {
  ensure_installed = lsp_servers,
  automatic_installation = true,
}

local opts = {}

for _, server in pairs(lsp_servers) do
  opts = defaults
  server = vim.split(server, "@")[1]

  if lsp_servers_custom[server] then
    opts = vim.tbl_extend("force", opts, lsp_servers_custom[server])
  end

  lspconfig[server].setup(opts)
  ::continue::
end

local signs = {
  Error = '󰇴 ',
  Warn = '󱚝 ',
  Info = '󰇳 ',
  Hint = '󱜙 '
}

vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = signs.Error,
      [vim.diagnostic.severity.WARN] = signs.Warn,
      [vim.diagnostic.severity.INFO] = signs.Info,
      [vim.diagnostic.severity.HINT] = signs.Hint,
    }
  },
  underline = true,
  float = { border = BORDER_STYLE },
})

local ns = vim.api.nvim_create_namespace('my_namespace')
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
  end
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
