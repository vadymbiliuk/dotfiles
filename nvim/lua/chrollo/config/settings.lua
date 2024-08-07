local in_dotfiles = vim.fn.system(
  'git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME ls-tree --name-only HEAD'
) ~= ''

local BORDER_STYLE = 'rounded'
local telescope_border_chars = {
  none = { '', '', '', '', '', '', '', '' },
  single = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
  double = { '═', '║', '═', '║', '╔', '╗', '╝', '╚' },
  rounded = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
  solid = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  shadow = { '', '', '', '', '', '', '', '' },
}
local connected_telescope_border_chars = {
  none = { '', '', '', '', '', '', '', '' },
  single = { '─', '│', '─', '│', '┌', '┐', '┤', '├' },
  double = { '═', '║', '═', '║', '╔', '╗', '╣', '╠' },
  rounded = { '─', '│', '─', '│', '╭', '╮', '┤', '├' },
  solid = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  shadow = { '', '', '', '', '', '', '', '' },
}

local M = {
  in_dotfiles = in_dotfiles,
  border = BORDER_STYLE,
  telescope_border_chars = telescope_border_chars[BORDER_STYLE],
  telescope_centered_picker = {
    results_title = false,
    layout_strategy = 'center',
    layout_config = {
      anchor = 'S',
      preview_cutoff = 1,
      prompt_position = 'bottom',
      width = 0.95,
      results_height = 5,
    },
    border = true,
    borderchars = {
      prompt = telescope_border_chars[BORDER_STYLE],
      results = connected_telescope_border_chars[BORDER_STYLE],
      preview = telescope_border_chars[BORDER_STYLE],
    },
  },
  lazy_loaded_colorschemes = {
    'lackluster',
  },
}

M.apply = function()
  local settings = {
    g = {
      -- This is sadly super slow sometimes. Look into making it faster?
      query_lint_on = {},
      bullets_checkbox_markers = ' x',
      bullets_outline_levels = { 'ROM', 'ABC', 'rom', 'abc', 'std-' },
      mapleader = ',',
      mkdp_echo_preview_url = 1,
      mkdp_preview_options = {
        maid = {
          theme = 'dark',
        },
      },
      mkdp_theme = 'dark',
      rustfmt_autosave = 1,
      haskell_tools = {
        tools = {
          codeLens = {
            -- we already set up this autocmd ourselves
            autoRefresh = false,
          },
        },
      },
      neovide_cursor_animate_in_insert_mode = false,
    },
    o = {
      cursorline = true,
      breakindent = true,
      whichwrap = "b,h,l",
      showbreak = "↳ ",
      updatetime = 300,
      clipboard = 'unnamedplus',
      backup = false,
      colorcolumn = '80',
      compatible = false,
      cpoptions = 'aABceFs', -- make `cw` compatible with other `w` operations
      diffopt = 'internal,filler,closeoff,linematch:60',
      encoding = 'utf-8',
      expandtab = true,
      fillchars = [[eob: ,fold: ,foldopen:▽,foldsep: ,foldclose:▷]],
      foldcolumn = '1',
      foldenable = true,
      foldlevel = 99,
      foldlevelstart = 99,
      foldmethod = 'expr',
      ignorecase = true,
      linespace = -1,
      list = true,
      mouse = '',
      number = true,
      pumheight = 10,
      relativenumber = true,
      scrolloff = 8,
      shiftwidth = 4,
      sidescrolloff = 5,
      signcolumn = 'number',
      smartcase = true,
      softtabstop = 4,
      splitright = true,
      swapfile = false,
      tabstop = 8,
      termguicolors = true,
      textwidth = 80,
      undodir = vim.env.HOME .. '/.vim/undodir',
      undofile = true,
      virtualedit = 'block,insert',
      wrap = false,
    },
    wo = {
      foldexpr = 'v:lua.vim.treesitter.foldexpr()',
      foldtext = '',
      linebreak = true,
    },
    opt = {
      wrap = true,
      completeopt = { 'menu', 'menuone', 'preview', 'noselect', 'noinsert' },
      listchars = { tab = '  ', nbsp = ' ' },
      list = false,
      shell = '/opt/homebrew/bin/fish',
      expandtab = true,
      display = 'lastline'
    },
    -- env = {
    --   GIT_WORK_TREE = in_dotfiles and vim.env.HOME or vim.env.GIT_WORK_TREE,
    --   GIT_DIR = in_dotfiles and vim.env.HOME .. '/.dotfiles' or vim.env.GIT_DIR,
    --   -- for constant paging in Telescope delta commands
    --   GIT_PAGER = 'delta --paging=always',
    -- },
  }

  -- apply the above settings
  for scope, ops in pairs(settings) do
    local op_group = vim[scope]
    for op_key, op_value in pairs(ops) do
      op_group[op_key] = op_value
    end
  end

  -- properly recognize more filetypes
  vim.filetype.add {
    filename = {
      -- recognize e.g. Github private keys as PEM files
      id_ed25519 = 'pem',
      -- properly recognize Git configuration for dotfiles
      ['~/.dotfiles/config'] = 'gitconfig',
    },
  }

  -- override `get_option` to allow for proper JSX/TSX commenting
  local get_option = vim.filetype.get_option
  local in_jsx = require('chrollo.config.utils').in_jsx_tags
  vim.filetype.get_option = function(filetype, option)
    if option ~= 'commentstring' then
      return get_option(filetype, option)
    end
    if filetype == 'javascriptreact' or filetype == 'typescriptreact' then
      local line = vim.api.nvim_get_current_line()
      if in_jsx(false) or line:match('^%s-{/%*.-%*/}%s-$') then
        return '{/*%s*/}'
      end
    end
    return get_option(filetype, option)
  end
end

return M
