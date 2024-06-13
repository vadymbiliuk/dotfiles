return {
    "samjwill/nvim-unception",
    event = "VeryLazy",
    init = function()
        vim.g.unception_delete_replaced_buffer = true
        vim.api.nvim_create_autocmd("User", {
            pattern = "UnceptionEditRequestReceived",
            callback = function()
                require("nvterm.terminal").hide "horizontal"
            end,
        })
    end,
}
