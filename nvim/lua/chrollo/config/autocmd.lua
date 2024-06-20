local create_autocmd = vim.api.nvim_create_autocmd
-- javascript-family files nvim-surround setup
create_autocmd('FileType', {
  pattern = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
  callback = function()
    local config = require('nvim-surround.config')
    ---@diagnostic disable-next-line: missing-fields
    require('nvim-surround').buffer_setup {
      surrounds = {
        ---@diagnostic disable-next-line: missing-fields
        F = {
          add = function()
            local result = require('nvim-surround.config').get_input(
              'Enter the function name: '
            )
            if result then
              if result == '' then
                return {
                  { '() => {' },
                  { '}' },
                }
              else
                return {
                  { 'function ' .. result .. '() {' },
                  { '}' },
                }
              end
            end
          end,
          find = function()
            return require('nvim-surround.config').get_selection {
              query = { capture = '@function.outer', type = 'textobjects' },
            }
          end,
          ---@param char string
          delete = function(char)
            local match = config.get_selections {
              char = char,
              --> INJECT: luap
              pattern = '^(function%s+[%w_]-%s-%(.-%).-{)().-(})()$',
            }
            if not match then
              match = config.get_selections {
                char = char,
                --> INJECT: luap
                pattern = '^(%(.-%)%s-=>%s-{)().-(})()$',
              }
            end
            return match
          end,
        },
      },
    }
  end,
})

create_autocmd("BufReadPost", {
  pattern = { "*" },
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.api.nvim_exec("normal! g'\"", false)
    end
  end
})

-->> "RUN ONCE" ON FILE OPEN COMMANDS <<--
-- prevent comment from being inserted when entering new line in existing comment
create_autocmd('BufWinEnter', {
  callback = function()
    vim.opt_local.formatoptions:remove { 'r', 'o' }
    vim.opt_local.bufhidden = 'delete'
  end,
})

-- nicer cmp docs highlights for Nvim 0.10
create_autocmd('FileType', {
  pattern = 'cmp_docs',
  callback = function(ev)
    vim.treesitter.start(ev.buf, 'markdown')
  end,
})

-- cool yank highlighting
create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank { higroup = 'Search' }
  end,
})

-- sane terminal options
create_autocmd('TermOpen', {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'
    vim.opt_local.foldcolumn = '0'
  end,
})
