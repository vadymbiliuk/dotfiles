vim.loader.enable()

local SETTINGS = require('chrollo.config.settings')
SETTINGS.apply()

require("chrollo.config.lazy")
require("chrollo.config.lsp")
require("chrollo.config.autocmd")
