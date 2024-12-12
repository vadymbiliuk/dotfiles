return {
	{ "nvim-tree/nvim-web-devicons" },
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			local color = require("lackluster").color

			vim.api.nvim_set_hl(0, "TreesitterContext", {
				ctermbg = 0,
				bg = color.gray1,
			})
			vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", {
				ctermbg = 0,
				bg = color.gray1,
			})
			vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", {
				ctermbg = 0,
				bg = color.gray1,
			})

			require("treesitter-context").setup({
				max_lines = 2,
				multiline_threshold = 1,
				mode = "cursor",
				separator = nil,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = "all",
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				scope = {
					enable = true,
				},
			})
			require("nvim-treesitter.install").prefer_git = true
		end,
	},
	{ "echasnovski/mini.icons", version = "*", config = true },
	{ "echasnovski/mini.trailspace", version = "*", config = true },
	{ "echasnovski/mini.cursorword", version = "*", config = true },
	{ "echasnovski/mini.statusline", version = "*", config = true },
	{
		"echasnovski/mini.tabline",
		version = "*",
		config = true,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		config = function()
			require("gitsigns").setup({
				attach_to_untracked = true,
				signs = {
					add = { text = "┃" },
					change = { text = "┃" },
					delete = { text = "•" },
					topdelete = { text = "•" },
					changedelete = { text = "•" },
					untracked = { text = "┃" },
				},
				current_line_blame = true,
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol",
					delay = 50,
					ignore_whitespace = false,
					virt_text_priority = 100,
				},
				current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
				signs_staged = {
					add = { text = "┃" },
					change = { text = "┃" },
					delete = { text = "•" },
					topdelete = { text = "•" },
					changedelete = { text = "•" },
					untracked = { text = "┃" },
				},
				sign_priority = 0,
				preview_config = {
					border = BORDER_STYLE,
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- next/prev git changes
					map({ "n", "x" }, "<leader>gj", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					map({ "n", "x" }, "<leader>gk", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					-- git preview
					map("n", "<leader>gp", gs.preview_hunk)
					-- git blame
					map("n", "<leader>gb", function()
						gs.blame_line({ full = true })
					end)
					-- undo git change
					map("n", "<leader>gu", gs.reset_hunk)
					map("x", "<leader>gu", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					-- undo all git changes
					map("n", "<leader>gr", gs.reset_buffer)
					-- stage git changes
					map("n", "<leader>ga", gs.stage_hunk)
					map("x", "<leader>ga", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					-- unstage git changes
					map("n", "<leader>gU", gs.undo_stage_hunk)
				end,
			})
		end,
	},
	{
		"luukvbaal/statuscol.nvim",
		priority = 100,
		config = function()
			local builtin = require("statuscol.builtin")

			require("statuscol").setup({
				relculright = true,
				segments = {
					{
						sign = {
							namespace = { "gitsigns" },
							maxwidth = 1,
							colwidth = 1,
							auto = false,
							fillchar = " ",
							fillcharhl = " ",
						},
						click = "v:lua.ScSa",
					},
					{
						sign = {
							namespace = { "diagnostic" },
							name = { "neotest_" },
							auto = false,
							wrap = true,
							fillchar = " ",
							fillcharhl = " ",
						},
						click = "v:lua.ScSa",
						condition = {
							function(args)
								return args.sclnu
							end,
						},
					},
					{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
					{ text = { builtin.foldfunc, " " }, click = "v:luaScFa" },
				},
			})
		end,
	},
	{ "aznhe21/actions-preview.nvim" },
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		opts = function()
			local dashboard = require("alpha.themes.dashboard")
			dashboard.opts.layout[1].val = 8

			dashboard.section.buttons.val = {
				{
					type = "text",
					val = " ",
					opts = {
						position = "center",
					},
				},
				dashboard.button("f", " Open file", ":lua require('telescope.builtin').find_files()<CR>"),
				dashboard.button("g", " Grep", ":lua require('telescope.builtin').live_grep()<CR>"),
				dashboard.button("b", " Buffers", ":lua require('telescope.builtin').buffers()<CR>"),
				dashboard.button("r", " Recent files", ":lua require('telescope.builtin').oldfiles()<CR>"),
				dashboard.button("h", " Help tags", ":lua require('telescope.builtin').help_tags()<CR>"),
				dashboard.button("o", " Open Oil", ":Oil<CR>"),
			}
			dashboard.opts.layout[3].val = 0
			dashboard.section.footer.opts.hl = "@alpha.footer"
			table.insert(dashboard.config.layout, 5, {
				type = "padding",
				val = 1,
			})
			return dashboard
		end,
		config = function(_, dashboard)
			-- close Lazy and re-open when the dashboard is ready
			if vim.o.filetype == "lazy" then
				vim.cmd.close()
				vim.api.nvim_create_autocmd("User", {
					pattern = "AlphaReady",
					callback = function()
						require("lazy").show()
					end,
				})
			end

			require("alpha").setup(dashboard.opts)
		end,
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-jest",
			"marilari88/neotest-vitest",
			"nvim-neotest/neotest-python",
		},
		keys = {
			{
				"<leader>t",
				"",
				desc = "+test",
			},
			{
				"<leader>tt",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run File",
			},
			{
				"<leader>tT",
				function()
					require("neotest").run.run(vim.uv.cwd())
				end,
				desc = "Run All Test Files",
			},
			{
				"<leader>tr",
				function()
					require("neotest").run.run()
				end,
				desc = "Run Nearest",
			},
			{
				"<leader>tl",
				function()
					require("neotest").run.run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle Summary",
			},
			{
				"<leader>to",
				function()
					require("neotest").output.open({ enter = true, auto_close = true })
				end,
				desc = "Show Output",
			},
			{
				"<leader>tO",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "Toggle Output Panel",
			},
			{
				"<leader>tS",
				function()
					require("neotest").run.stop()
				end,
				desc = "Stop",
			},
			{
				"<leader>tw",
				function()
					require("neotest").watch.toggle(vim.fn.expand("%"))
				end,
				desc = "Toggle Watch",
			},
			{
				"<leader>ti",
				"<cmd>lua require('neotest').run.run({ jestCommand = 'INTEGRATION=1 jest' })<cr>",
				desc = "Toggle Watch",
			},
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-jest")({
						jestCommand = "npm run test:js --",
						jestConfigFile = "jest.config.ts",
						env = { CI = true },
						cwd = function()
							return vim.fn.getcwd()
						end,
					}),
					require("neotest-vitest"),
					require("neotest-python")({
						dap = { justMyCode = false },
					}),
				},
				icons = {
					expanded = "",
					child_prefix = "",
					child_indent = "",
					final_child_prefix = "",
					non_collapsible = "",
					collapsed = "",

					passed = "󰇳 ",
					failed = "󰇴 ",
					running = "",
					unknown = "󱚝 ",
				},
			})
		end,
	},
	{
		"folke/edgy.nvim",
		event = "VeryLazy",
		init = function()
			local edgy = require("edgy")
			vim.opt.splitkeep = "screen"

			vim.keymap.set("n", "<space>e", function()
				edgy.toggle("left")
				edgy.toggle("right")
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
				},
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
	},
	{
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
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim" },
		},
		build = "make tiktoken",
		opts = {
			config = { chat_autocomplete = true },
		},
		config = function()
			require("CopilotChat").setup()
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
}
