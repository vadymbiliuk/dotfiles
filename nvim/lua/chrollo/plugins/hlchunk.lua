return {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
        require('hlchunk').setup({
            chunk = {
                enable = true,
                delay = 0,
                style = {
                    { fg = "#DEEEED" },
                },
            },
            indent = {
                enable = false
            },
            blank = {
                enable = true
            },
            line_num = {
                enable = false,
                priority = 10,
                use_treesitter = true,
                style = {
                    { fg = "#DEEEED" },
                },
            }
        })
    end
}
