-- Thanks to https://github.com/dmtrKovalenko/my-nvim-config/blob/main/lua/sidebar.lua
return {
	"folke/edgy.nvim",
	event = "VeryLazy",
	init = function()
		local edgy = require "edgy"
		vim.opt.splitkeep = "screen"

		vim.keymap.set("n", "<space>e", function()
			edgy.toggle "left"
			edgy.toggle "right"
		end, { desc = "Toggle sidebar" })
	end,
	dependencies = {
		{
			"nvim-neotest/neotest",
			"nvim-neotest/neotest-jest",
			"nvim-neotest/neotest-python",
		},
		{
			"folke/trouble.nvim",
			branch = "main",
			keys = {
				{
					"<leader>tm",
					"<cmd>Trouble diagnostics toggle<cr>",
					desc = "Diagnostics (Trouble)",
				},
				{
					"<leader>ts",
					"<cmd>Trouble symbols toggle<cr>",
					desc = "Symbols (Trouble)",
				},
				-- {
				-- 	"<leader>tl",
				-- 	"<cmd>Trouble loclist toggle<cr>",
				-- 	desc = "Location List (Trouble)",
				-- },
			},
			opts = {}, -- for default options, refer to the configuration section for custom setup.
			init = function()
				vim.api.nvim_create_autocmd("BufReadPost", {
					pattern = "*",
					callback = function()
						require("trouble").refresh()
					end,
				})
			end,
		},
	},
	opts = {
		options = {
			left = {
				size = 35,
			},
			right = {
				size = 35,
			},
		},
		close_when_all_hidden = true,
		right = {
			{
				ft = "Neotest",
				pinned = true,
				title = "Test",
				open = "Neotest summary",
				size = { height = 0.5 },
			}
		},
		left = {

			-- Neo-tree filesystem always takes half the screen height
			{
				ft = "trouble",
				pinned = true,
				title = "Sidebar",
				filter = function(_buf, win)
					return vim.w[win].trouble.mode == "symbols"
				end,
				open = "Trouble symbols position=left focus=false filter.buf=0",
				size = { height = 0.6 },
			},
			{
				ft = "trouble",
				pinned = true,
				title = "Troubles",
				filter = function(_buf, win)
					return vim.w[win].trouble.mode == "diagnostics"
				end,
				open = "Trouble diagnostics focus=false filter.severity=vim.diagnostic.severity.ERROR",
				size = { height = 0.4 },
			},
		},
	},
}
