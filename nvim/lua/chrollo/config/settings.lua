vim.g.mapleader = ","
vim.g.localleader = ','
vim.g.kitty_fast_forwarded_modifiers = "super"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.wo.number = true
vim.wo.relativenumber = true

vim.o.mouse = "a"

vim.opt.foldmethod = 'indent'
vim.o.foldcolumn = '0'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.opt.fillchars = { eob = " " }

vim.opt.tabpagemax = 50
vim.o.scrolloff = 8
vim.o.showbreak = "↳ "
vim.o.showtabline = 0
vim.o.sidescroll = 1
vim.o.sidescrolloff = 15
vim.cmd('syntax enable')
vim.opt.display = 'lastline'
vim.opt.encoding = 'utf-8'
vim.opt.wrap = true
vim.opt.nrformats:remove("octal") -- Interpret octal as decimal when incrementing numbers.
vim.opt.shell =
"/opt/homebrew/bin/fish"          -- The shell used to execute commands. Replace "/bin/bash" with your preferred shell.

vim.o.virtualedit = "onemore"
vim.o.whichwrap = "b,h,l"
vim.o.wildmode = "longest,full"
vim.o.wildoptions = "pum"
vim.wo.foldenable = false
vim.wo.foldlevel = 2
vim.wo.foldmethod = "indent"
vim.wo.linebreak = true

vim.o.clipboard = "unnamedplus"
vim.o.showmode = false

vim.o.breakindent = true

vim.o.backup = false
vim.o.undofile = true
vim.o.swapfile = false

vim.o.ignorecase = true
vim.o.smartcase = true

vim.wo.signcolumn = "yes"

vim.o.timeout = true
vim.o.timeoutlen = 250

vim.o.textwidth = 80

vim.o.updatetime = 300

vim.o.cursorline = true

vim.o.completeopt = "menuone,noselect"

vim.o.termguicolors = true

vim.opt.list = true
vim.opt.listchars = vim.opt.listchars + " "

vim.opt.title = true
vim.opt.titlestring = '%t%( (%{fnamemodify(getcwd(), ":~:.")})%)'

vim.opt.fillchars = {
  eob = ' ', -- suppress ~ at EndOfBuffer
  diff = '╱', -- alternatives = ⣿ ░ ─
  msgsep = ' ', -- alternatives: ‾ ─
  fold = ' ',
  foldopen = '▽', -- '▼'
  foldclose = '▷', -- '▶'
  foldsep = ' ',
}

vim.opt.listchars = {
  eol = nil,
  tab = '  ', -- Alternatives: '▷▷',
  extends = '…', -- Alternatives: … » ›
  precedes = '░', -- Alternatives: … « ‹
  trail = '•', -- BULLET (U+2022, UTF-8: E2 80 A2)
}

vim.opt.guicursor = {
  'n-v-c-sm:block-Cursor',
  'i-ci-ve:ver25-iCursor',
  'r-cr-o:hor20-Cursor',
  'a:blinkon0',
}
vim.opt.cursorlineopt = { 'both' }

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "javascript", "css", "html", "json", "yaml", "markdown" },
  callback = function()
    vim.opt.iskeyword:append { "-", "#", "$" }
  end,
})
