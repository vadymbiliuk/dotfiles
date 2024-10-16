return {
	{
		"slugbyte/lackluster.nvim",
		lazy = false,
		priority = 1000,
		init = function()
			local lackluster = require("lackluster")
			require("nvim-web-devicons").setup({
				color_icons = false,
				override = {
					["default_icon"] = {
						color = lackluster.color.gray4,
						name = "Default",
					},
				},
			})
			local color = require("lackluster").color
			lackluster.setup({
				tweak_background = {
					popup = "#101010",
				},
				tweak_highlight = {
					["@keyword"] = {
						bold = true,
						italic = false,
					},
					["@function"] = {
						link = "@keyword",
					},
				},
				tweak_background = {
					menu = color.gray1,
					popup = color.gray1,
				},
			})

			vim.cmd.colorscheme("lackluster")
		end,
	},
}
