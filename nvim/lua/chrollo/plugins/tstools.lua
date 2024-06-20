return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  opts = {
    settings = {
      tsserver_file_preferences = {
        -- NOTE: Should only really enable this if working in a Tree-sitter
        -- grammar
        disableSuggestions = false,
      },
    },
  },
}
