local function has_biome_config()
  local uv = vim.loop
  local cwd = uv.cwd()
  local biome_path = cwd .. "/biome.json"
  local stat = uv.fs_stat(biome_path)
  return stat ~= nil
end

return {
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
        javascript = has_biome_config() and { "biome" } or { "prettierd" },
        markdown = { { "prettierd", "prettier" } },
        typescript = has_biome_config() and { "biome" } or { "prettierd" },
        typescriptreact = has_biome_config() and { "biome" } or { "prettierd" },
        javascriptreact = has_biome_config() and { "biome" } or { "prettierd" },
        css = { { "prettierd" } },
        json = has_biome_config() and { "biome" } or { "prettierd" },
        yaml = { { "prettierd" } },
        graphql = { { "prettierd" } },
        rescript = { "rescript" },
        ocaml = { "ocamlformat" },
        prisma = { "prisma format" },
        nix = { "nixfmt" },
        haskell = { "fourmolu" },
        cabal = { 'cabal-fmt --inplace' }
      },
    }
  end,
}
