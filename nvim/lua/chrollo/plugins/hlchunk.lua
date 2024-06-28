return {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
        require('hlchunk').setup({
            chunk = {
                enable = true,
                delay = 0,
            },
            indent = {
                enable = true
            },
            line_num = {
                enable = true,
                priority = 10,
                use_treesitter = true,
            }
        })
    end
}
