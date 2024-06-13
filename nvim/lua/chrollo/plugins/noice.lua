return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        presets = {
            lsp_doc_border = false,
        },
        lsp = {
            hover = {
                enabled = false,
            },
        },
        progress = {
            max_width = 0.3,
        },
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
}
