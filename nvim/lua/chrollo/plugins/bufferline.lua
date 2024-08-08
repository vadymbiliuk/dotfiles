return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        require('bufferline').setup {
            options = {
                numbers = 'ordinal',
                diagnostics = 'nvim_lsp',
                show_buffer_close_icons = false,
                show_close_icon = false,
                persist_buffer_sort = true,
                enforce_regular_tabs = false,
                always_show_bufferline = true,
                offsets = {
                    { filetype = "NvimTree",      text = "Files",          text_align = "center" },
                    { filetype = "DiffviewFiles", text = "Source Control", text_align = "center" }
                }
            }
        }
    end
}
