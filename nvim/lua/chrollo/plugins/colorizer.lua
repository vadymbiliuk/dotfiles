return {
    "norcalli/nvim-colorizer.lua",
    lazy = false,
    priority = 1000,
    config = function()
        require('colorizer').setup({
            ["*"] = {
                names = false,
            },
        })
    end
}
