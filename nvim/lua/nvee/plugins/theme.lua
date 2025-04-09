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
				tweak_highlight = {
					["@keyword"] = {
						bold = true,
						italic = false,
					},
					["@function"] = {
						link = "@keyword",
					},
				},
				tweak_syntax = {
					comment = lackluster.color.gray4,
				},
				tweak_background = {
					normal = "none",
					telescope = "none",
					menu = color.gray3,
					popup = "none",
				},
			})

			vim.cmd.colorscheme("lackluster")
			vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#3c4048", bg = "none" })
			vim.api.nvim_set_hl(0, "TroubleNormal", { bg = "none", ctermbg = "none" })
			vim.api.nvim_set_hl(0, "TroubleNormalNC", { bg = "none", ctermbg = "none" })
			vim.api.nvim_set_hl(0, "TroubleNormal", { bg = "none", ctermbg = "none" })
			vim.api.nvim_set_hl(0, "TroubleNormalNC", { bg = "none", ctermbg = "none" })
		end,
	},
	{
		"xiyaowong/transparent.nvim",
		lazy = false,
		opts = {},
	},
}
