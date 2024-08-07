return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('lualine').setup {
            options = {
                section_separators = '',
                component_separators = '',
                theme = 'lackluster'
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', {
                    'diagnostics',
                    sources = { 'nvim_diagnostic' },
                    sections = { 'error', 'warn', 'info', 'hint' },
                    diagnostics_color = {
                        -- Same values as the general color option can be used here.
                        error = 'DiagnosticError', -- Changes diagnostics' error color.
                        warn  = 'DiagnosticWarn',  -- Changes diagnostics' warn color.
                        info  = 'DiagnosticInfo',  -- Changes diagnostics' info color.
                        hint  = 'DiagnosticHint',  -- Changes diagnostics' hint color.
                    },
                    symbols = {
                        error = '󰇴 ',
                        warn = '󱚝 ',
                        info = '󰇳 ',
                        hint = '󱜙 '

                    },
                    colored = true,           -- Displays diagnostics status in color if set to true.
                    update_in_insert = false, -- Update diagnostics in insert mode.
                    always_visible = false,   -- Show diagnostics even if there are none.
                }
                },
                lualine_c = { 'filename' },
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
        }
    end
}
