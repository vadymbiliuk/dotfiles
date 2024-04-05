return {
    'lewis6991/gitsigns.nvim',
    config = function()
        require('gitsigns').setup {
            signs = {
                add = { hl = 'diffAdded', text = '┃', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
                change = { hl = 'diffChanged', text = '┃', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
                delete = { hl = 'diffRemoved', text = '•', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
                changedelete = { hl = 'diffChanged', text = '•', numhl = 'GitSignsChangeNr',
                    linehl = 'GitSignsChangeLn' },
                topdelete = { hl = 'diffRemoved', text = '•', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
            },
            current_line_blame = true,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol',
                delay = 300,
                ignore_whitespace = false,
                virt_text_priority = 100,
            },
            current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        }
    end
}
