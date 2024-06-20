return {
    'neovim/nvim-lspconfig',
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
        require('chrollo.plugins.lspconfig')
    end
}
