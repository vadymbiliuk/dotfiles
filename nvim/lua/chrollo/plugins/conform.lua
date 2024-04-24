return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup {
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        python = { "ruff format" },
        javascript = { { "prettierd", "prettier" }, { "eslint" } },
        markdown = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },
        javascriptreact = { { "prettierd", "prettier" } },
        css = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        yaml = { { "prettierd", "prettier" } },
        graphql = { { "prettierd", "prettier" } },
        rescript = { "rescript" },
        ocaml = { "ocamlformat" },
        prisma = { "prisma format" },
        nix = { "nixfmt" }
      },
    }

    local function format()
      require("conform").format {
      }
    end

    vim.keymap.set({ "n", "i" }, "<F12>", format, { desc = "Format", silent = true })
    vim.api.nvim_create_user_command("Format", format, { desc = "Format current buffer with LSP" })
  end,
}
