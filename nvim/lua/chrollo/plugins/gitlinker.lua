return {
    "ruifm/gitlinker.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("gitlinker").setup()
        vim.api.nvim_set_keymap(
            "n",
            "<leader>gl",
            '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
            { silent = true, desc = "Open git link in the browser" }
        )
    end,
}
