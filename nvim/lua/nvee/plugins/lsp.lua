local function has_biome_config()
	local uv = vim.loop
	local cwd = uv.cwd()
	local biome_path = cwd .. "/biome.json"
	local stat = uv.fs_stat(biome_path)
	return stat ~= nil
end

return {
	-- {
	-- 	"mrcjkb/haskell-tools.nvim",
	-- 	version = "^4",
	-- 	lazy = false,
	-- },
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				notify_on_error = true,
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
				formatters_by_ft = {
					lua = { "stylua" },
					rust = { "rustfmt" },
					c = { "clang-format" },
					cpp = { "clang-format" },
					python = { "ruff format" },
					javascript = has_biome_config() and { "biome" } or { "prettierd" },
					markdown = { "prettierd", "prettier" },
					typescript = has_biome_config() and { "biome" } or { "prettierd" },
					typescriptreact = has_biome_config() and { "biome" } or { "prettierd" },
					javascriptreact = has_biome_config() and { "biome" } or { "prettierd" },
					json = has_biome_config() and { "biome" } or { "prettierd" },
					yaml = { "yamlfmt" },
					graphql = { "prettierd" },
					recript = { "rescript" },
					ocaml = { "ocamlformat" },
					prisma = { "prisma format" },
					nix = { "nixfmt" },
					haskell = { "fourmolu", "stylish-haskell" },
					cabal = { "cabal-fmt --inplace" },
				},
			})
		end,
	},
	-- {
	-- 	"mfussenegger/nvim-lint",
	-- 	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	-- 	opts = {
	-- 		-- Event to trigger linters
	-- 		events = { "BufWritePost", "BufReadPost", "InsertLeave" },
	-- 		linters_by_ft = {
	-- 			fish = { "fish" },
	-- 			javascript = { "eslint" },
	-- 			javascriptreact = { "eslint" },
	-- 			typescriptreact = { "eslint" },
	-- 			typescript = { "eslint" },
	-- 			-- Use the "*" filetype to run linters on all filetypes.
	-- 			-- ['*'] = { 'global linter' },
	-- 			-- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
	-- 			-- ['_'] = { 'fallback linter' },
	-- 			-- ["*"] = { "typos" },
	-- 		},
	-- 		-- LazyVim extension to easily override linter options
	-- 		-- or add custom linters.
	-- 		---@type table<string,table>
	-- 		linters = {
	-- 			"eslint_d",
	-- 		},
	-- 	},
	-- 	config = function(_, opts)
	-- 		local M = {}
	--
	-- 		local lint = require("lint")
	-- 		for name, linter in pairs(opts.linters) do
	-- 			if type(linter) == "table" and type(lint.linters[name]) == "table" then
	-- 				lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
	-- 				if type(linter.prepend_args) == "table" then
	-- 					lint.linters[name].args = lint.linters[name].args or {}
	-- 					vim.list_extend(lint.linters[name].args, linter.prepend_args)
	-- 				end
	-- 			else
	-- 				lint.linters[name] = linter
	-- 			end
	-- 		end
	-- 		lint.linters_by_ft = opts.linters_by_ft
	--
	-- 		function M.debounce(ms, fn)
	-- 			local timer = vim.uv.new_timer()
	-- 			return function(...)
	-- 				local argv = { ... }
	-- 				timer:start(ms, 0, function()
	-- 					timer:stop()
	-- 					vim.schedule_wrap(fn)(unpack(argv))
	-- 				end)
	-- 			end
	-- 		end
	--
	-- 		function M.lint()
	-- 			-- Use nvim-lint's logic first:
	-- 			-- * checks if linters exist for the full filetype first
	-- 			-- * otherwise will split filetype by "." and add all those linters
	-- 			-- * this differs from conform.nvim which only uses the first filetype that has a formatter
	-- 			local names = lint._resolve_linter_by_ft(vim.bo.filetype)
	--
	-- 			-- Create a copy of the names table to avoid modifying the original.
	-- 			names = vim.list_extend({}, names)
	--
	-- 			-- Add fallback linters.
	-- 			if #names == 0 then
	-- 				vim.list_extend(names, lint.linters_by_ft["_"] or {})
	-- 			end
	--
	-- 			-- Add global linters.
	-- 			vim.list_extend(names, lint.linters_by_ft["*"] or {})
	--
	-- 			-- Filter out linters that don't exist or don't match the condition.
	-- 			local ctx = { filename = vim.api.nvim_buf_get_name(0) }
	-- 			ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
	-- 			names = vim.tbl_filter(function(name)
	-- 				local linter = lint.linters[name]
	-- 				if not linter then
	-- 					require("noice").notify(
	-- 						"Linter not found: " .. name,
	-- 						vim.log.levels.WARN,
	-- 						{ title = "nvim-lint" }
	-- 					)
	-- 				end
	-- 				return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
	-- 			end, names)
	--
	-- 			-- Run linters.
	-- 			if #names > 0 then
	-- 				lint.try_lint(names)
	-- 			end
	-- 		end
	--
	-- 		vim.api.nvim_create_autocmd(opts.events, {
	-- 			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
	-- 			callback = M.debounce(100, M.lint),
	-- 		})
	-- 	end,
	-- },
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "yioneko/nvim-vtsls" },
		},
		config = function()
			local lspconfig = require("lspconfig")
			local lsp_util = require("lspconfig.util")

			local lsp_servers = {
				"vtsls",
				"bashls",
				"dockerls",
				"pyright",
				"ruff",
				"vimls",
				"yamlls",
				"vuels",
				"svelte",
				"graphql",
				"rust_analyzer",
				"jsonls",
				"lua_ls",
				"nil_ls",
				"biome",
				"tailwindcss",
				"ocamllsp",
				"grammarly",
				"hls",
				"eslint",
			}

			require("vtsls").config({})

			local lsp_servers_custom = {
				tailwindcss = {
					root_dir = function(fname)
						return lsp_util.root_pattern("tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs")(
							fname
						)
					end,
					settings = {
						tailwindCSS = {
							experimental = {
								classRegex = {
									-- clsx, cn
									-- https://github.com/tailwindlabs/tailwindcss-intellisense/issues/682#issuecomment-1364585313
									{ [[clsx\(([^)]*)\)]], [["([^"]*)"]] },
									{ [[cn\(([^)]*)\)]], [["([^"]*)"]] },
									-- Tailwind Variants
									-- https://www.tailwind-variants.org/docs/getting-started#intellisense-setup-optional
									{ [[tv\(([^)]*)\)]], [==[["'`]([^"'`]*).*?["'`]]==] },
								},
							},
						},
					},
				},
				pyright = {
					settings = {
						pyright = {
							-- Using Ruff's import organizer
							disableOrganizeImports = true,
						},
						python = {
							analysis = {
								-- Ignore all files for analysis to exclusively use Ruff for linting
								ignore = { "*" },
							},
						},
					},
				},
				ruff = {
					init_options = {
						settings = {
							args = {},
						},
					},
				},
				lua_ls = {
					single_file_support = true,
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							completion = {
								workspaceWord = true,
								callSnippet = "Both",
							},
							misc = {
								parameters = {},
							},
							hover = { expandAlias = false },
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
							doc = {
								privateName = { "^_" },
							},
							type = {
								castNumberToInteger = true,
							},
							diagnostics = {
								disable = { "incomplete-signature-doc", "trailing-space" },
								groupSeverity = {
									strong = "Warning",
									strict = "Warning",
								},
								groupFileStatus = {
									["ambiguity"] = "Opened",
									["await"] = "Opened",
									["codestyle"] = "None",
									["duplicate"] = "Opened",
									["global"] = "Opened",
									["luadoc"] = "Opened",
									["redefined"] = "Opened",
									["strict"] = "Opened",
									["strong"] = "Opened",
									["type-check"] = "Opened",
									["unbalanced"] = "Opened",
									["unused"] = "Opened",
								},
								unusedLocalExclude = { "_*" },
							},
							format = {
								enable = true,
								defaultConfig = {
									indent_style = "space",
									indent_size = "2",
									continuation_indent_size = "2",
								},
							},
						},
					},
				},
			}

			-- on attach function
			local on_attach = function(client, bufnr)
				local function buf_set_keymap(...)
					vim.api.nvim_buf_set_keymap(bufnr, ...)
				end
				local opts = { noremap = true, silent = true }
				buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
				buf_set_keymap("n", "gw", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
				buf_set_keymap("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", opts)
				buf_set_keymap("n", "<leader>ga", '<cmd>lua require("actions-preview").code_actions()<CR>', opts)
				buf_set_keymap("v", "<leader>ga", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
				buf_set_keymap("i", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
				buf_set_keymap("n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
				buf_set_keymap("n", "<leader>gr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
				buf_set_keymap("n", "g]", "<cmd>lua vim.diagnostic.goto_next({ float = true })<CR>", opts)
				buf_set_keymap("n", "g[", "<cmd>lua vim.diagnostic.goto_prev({ float = true })<CR>", opts)
				buf_set_keymap("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			-- optimizes cpu usage source https://github.com/neovim/neovim/issues/23291
			capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

			-- LSP settings (for overriding per client)
			local handlers = {
				["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {}),
				["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {}),
			}

			local defaults = {
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
				end,
				capabilities = capabilities,
				handlers = handlers,
			}

			local opts = {}

			for _, server in pairs(lsp_servers) do
				opts = defaults
				server = vim.split(server, "@")[1]

				if lsp_servers_custom[server] then
					opts = vim.tbl_extend("force", opts, lsp_servers_custom[server])
				end

				lspconfig[server].setup(opts)
				::continue::
			end

			local signs = {
				Error = "󰇴 ",
				Warn = "󱚝 ",
				Info = "󰇳 ",
				Hint = "󱜙 ",
			}

			vim.diagnostic.config({
				virtual_text = false,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = signs.Error,
						[vim.diagnostic.severity.WARN] = signs.Warn,
						[vim.diagnostic.severity.INFO] = signs.Info,
						[vim.diagnostic.severity.HINT] = signs.Hint,
					},
				},
				underline = true,
			})

			local ns = vim.api.nvim_create_namespace("my_namespace")
			local orig_signs_handler = vim.diagnostic.handlers.signs
			vim.diagnostic.handlers.signs = {
				show = function(_, bufnr, _, opts)
					-- Get all diagnostics from the whole buffer rather than just the
					-- diagnostics passed to the handler
					local diagnostics = vim.diagnostic.get(bufnr)
					-- Find the "worst" diagnostic per line
					local max_severity_per_line = {}
					for _, d in pairs(diagnostics) do
						local m = max_severity_per_line[d.lnum]
						if not m or d.severity < m.severity then
							max_severity_per_line[d.lnum] = d
						end
					end
					-- Pass the filtered diagnostics (with our custom namespace) to
					-- the original handler
					local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
					orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
				end,
				hide = function(_, bufnr)
					orig_signs_handler.hide(ns, bufnr)
				end,
			}

			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
				callback = function()
					vim.diagnostic.open_float(nil, { focus = false })
				end,
			})

			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})

			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, {
				desc = "Re-enable autoformat-on-save",
			})
		end,
	},
}
