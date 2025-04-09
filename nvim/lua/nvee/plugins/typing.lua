return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
		end,
	},
	{
		"saghen/blink.cmp",
		lazy = false,
		dependencies = {
			"rafamadriz/friendly-snippets",
			"giuxtaposition/blink-cmp-copilot",
		},
		version = "v0.*",
		config = function()
			require("copilot").setup({
				enabled = true,
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
			require("blink.cmp").setup({
				signature = { enabled = true },
				cmdline = {
					completion = {
						ghost_text = { enabled = true },
						menu = {
							auto_show = function(ctx)
								return vim.fn.getcmdtype() == ":"
								-- enable for inputs as well, with:
								-- or vim.fn.getcmdtype() == '@'
							end,
						},
					},
				},
				keymap = {
					["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
					["<C-e>"] = { "hide" },
					["<C-y>"] = { "select_and_accept" },
					["<Up>"] = { "select_prev", "fallback" },
					["<Down>"] = { "select_next", "fallback" },
					["<C-p>"] = { "select_prev", "fallback_to_mappings" },
					["<C-n>"] = { "select_next", "fallback_to_mappings" },

					["<C-b>"] = { "scroll_documentation_up", "fallback" },
					["<C-f>"] = { "scroll_documentation_down", "fallback" },

					["<Tab>"] = { "snippet_forward", "fallback" },
					["<S-Tab>"] = { "snippet_backward", "fallback" },

					["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
					["<CR>"] = { "accept", "fallback" },
				},
				sources = {
					default = { "lsp", "path", "snippets", "buffer", "copilot" },
					providers = {
						copilot = {
							name = "copilot",
							module = "blink-cmp-copilot",
							score_offset = 100,
							async = true,
						},
					},
				},
			})
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			modes = {
				search = {
					enabled = true,
				},
			},
		},
	},
	{ "echasnovski/mini.surround", version = "*", config = true },
	{
		"echasnovski/mini.move",
		version = "*",
		opts = {
			mappings = {
				left = "<C-h>",
				right = "<C-l>",
				down = "<C-j>",
				up = "<C-k>",

				line_left = "<C-h>",
				line_right = "<C-l>",
				line_down = "<C-j>",
				line_up = "<C-k>",
			},

			options = {
				reindent_linewise = true,
			},
		},
	},
	{
		"echasnovski/mini.pairs",
		version = "*",
		config = true,
	},
	{
		"windwp/nvim-ts-autotag",
		config = true,
	},
	{
		"nvim-pack/nvim-spectre",
		config = function()
			require("spectre").setup({
				default = {
					replace = {
						cmd = "sed",
					},
				},
			})

			vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
				desc = "Toggle Spectre",
			})
			vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
				desc = "Search current word",
			})
			vim.keymap.set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
				desc = "Search current word",
			})
			vim.keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
				desc = "Search on current file",
			})
		end,
	},
	{ "numToStr/Comment.nvim" },
}
