local M = {}

function M.setup(path)
  vim.loader.enable()

  local settings = {
    g = {
      mapleader = ",",
      maplocalleader = ",",
      mkdp_preview_options = {
        maid = {
          theme = "dark",
        },
      },
      mkdp_theme = "dark",
      haskell_tools = {
        tools = {
          codeLens = {
            autoRefresh = false,
          },
        },
      },
    },
    o = {
      cursorline = true,
      breakindent = true,
      whichwrap = "b,h,l",
      showbreak = "↳ ",
      updatetime = 300,
      clipboard = "unnamedplus",
      backup = false,
      colorcolumn = "80",
      compatible = false,
      cpoptions = "aABceFs", -- make `cw` compatible with other `w` operations
      diffopt = "internal,filler,closeoff,linematch:60",
      encoding = "utf-8",
      expandtab = true,
      fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]],
      foldcolumn = "1",
      foldenable = true,
      foldlevel = 99,
      foldlevelstart = 99,
      foldmethod = "expr",
      ignorecase = true,
      linespace = -1,
      list = true,
      mouse = "",
      number = true,
      pumheight = 10,
      relativenumber = true,
      scrolloff = 8,
      shiftwidth = 4,
      sidescrolloff = 5,
      signcolumn = "number",
      smartcase = true,
      softtabstop = 4,
      splitright = true,
      swapfile = true,
      tabstop = 4,
      termguicolors = true,
      textwidth = 0,
      wrapmargin = 0,
      undodir = vim.env.HOME .. "/.vim/undodir",
      undofile = true,
      virtualedit = "block,insert",
      wrap = false,
      winborder = "rounded",
      autoread = true,
    },
    wo = {
      foldexpr = "v:lua.vim.treesitter.foldexpr()",
      foldtext = "",
      linebreak = true,
    },
    opt = {
      wrap = true,
      completeopt = { "menu", "menuone", "preview", "noselect", "noinsert" },
      listchars = vim.opt.listchars + "space:·",
      list = true,
      expandtab = true,
      display = "lastline",
      spell = true,
      spelllang = "en_us",
      spelloptions = "camel",
      conceallevel = 1,
    },
  }

  for scope, ops in pairs(settings) do
    local op_group = vim[scope]
    for op_key, op_value in pairs(ops) do
      op_group[op_key] = op_value
    end
  end
end

return M
