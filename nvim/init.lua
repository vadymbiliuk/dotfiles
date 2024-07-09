vim.loader.enable()

local SETTINGS = require('chrollo.config.settings')
SETTINGS.apply()

require("chrollo.config.lazy")
require("chrollo.config.lsp")
require("chrollo.config.autocmd")

-- Enable curly underlines for specific highlight groups
vim.cmd [[highlight Error guisp=#D70000 gui=undercurl term=undercurl cterm=undercurl]]
vim.cmd [[highlight Warning guisp=#ffAA88 gui=undercurl term=undercurl cterm=undercurl]]
vim.cmd [[highlight Hint guisp=#7788AA gui=undercurl term=undercurl cterm=undercurl]]
vim.cmd [[highlight Info guisp=#789978 gui=undercurl term=undercurl cterm=undercurl]]
