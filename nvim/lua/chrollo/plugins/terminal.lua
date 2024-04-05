return {
  "NvChad/nvterm",
  event = "BufWinEnter",
  opts = {
    terminals = {
      type_opts = {
        horizontal = {
          split_ratio = ((vim.api.nvim_get_option_value("lines", {}) < 60) and 0.5) or 0.3,
        },
      },
    },
  },
  init = function()
    vim.keymap.set({ "n", "t" }, "<C-/>", function()
      require("nvterm.terminal").toggle "horizontal"
    end, {})
  end,
}

