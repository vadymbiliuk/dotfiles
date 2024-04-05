local api = vim.api
vim.o.completeopt = "menu,menuone,noselect"

return {
    'hrsh7th/nvim-cmp',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'saadparwaiz1/cmp_luasnip',
        'onsails/lspkind.nvim',
    },
    config = function()
        local cmp = require'cmp'
        local lspkind = require'lspkind'
        local luasnip = require'luasnip'
        local ellipsis = '…'
        local MIN_MENU_WIDTH, MAX_MENU_WIDTH = 25, math.min(50, math.floor(vim.o.columns * 0.5))

        local function has_words_before()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and string.match(vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col), "%s") == nil
        end

        cmp.setup({
            experimental = {ghost_text = true},
            performance = { max_view_entries = 7 },
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            window = {
                documentation = {
                    border = 'solid'
                },
                completion = {
                    col_offset = 1,
                    side_padding = 0,
                    scrollbar = false
                }
            },
            view = {entries = {name = 'custom', selection_order = 'near_cursor'}},
            sources = {
                { name = 'nvim_lsp', group_index = 1 },
                { name = 'path', group_index = 1 },
                {
                    name = 'rg',
                    keyword_length = 4,
                    option = { additional_arguments = '--max-depth 8' },
                    group_index = 1,
                },
                {
                    name = 'buffer',
                    options = { get_bufnrs = function() return vim.api.nvim_list_bufs() end },
                    group_index = 2,
                },
                { name = 'spell', group_index = 2 },
                { name = "luasnip", group_index = 2 },
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Enter>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                },
                ["<Tab>"] = cmp.mapping(function(fallback)
                    -- provide a value for copilot to fallback if there is no suggestion to accept. If no suggestion accept mimic normal tab behavior.
                    local tab_shift_width = vim.opt.shiftwidth:get()
                    local copilot_keys = vim.fn["copilot#Accept"](string.rep(" ", tab_shift_width))

                    if luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    elseif copilot_keys ~= "" and type(copilot_keys) == "string" then
                        vim.api.nvim_feedkeys(copilot_keys, "i", true)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            formatting = {
                format = lspkind.cmp_format({
                    mode = 'symbol',
                    maxwidth = MAX_MENU_WIDTH,
                    ellipsis_char = ellipsis,
                    before = function(_, vim_item)
                        local label, length = vim_item.abbr, api.nvim_strwidth(vim_item.abbr)
                        if length < MIN_MENU_WIDTH then vim_item.abbr = label .. string.rep(' ', MIN_MENU_WIDTH - length) end
                        return vim_item
                    end,
                    symbol_map = { 
                        Text = "󰉿",
                        Method = "󰆧",
                        Function = "󰊕",
                        Constructor = "",
                        Field = "󰜢",
                        Variable = "󰀫",
                        Class = "󰠱",
                        Interface = "",
                        Module = "",
                        Property = "󰜢",
                        Unit = "󰑭",
                        Value = "󰎠",
                        Enum = "",
                        Keyword = "󰌋",
                        Snippet = "",
                        Color = "󰏘",
                        File = "󰈙",
                        Reference = "󰈇",
                        Folder = "󰉋",
                        EnumMember = "",
                        Constant = "󰏿",
                        Struct = "󰙅",
                        Event = "",
                        Operator = "󰆕",
                        TypeParameter = "",
                    },
                })
            }
        })

        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true

        cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
                { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
            }, {
                { name = 'buffer' },
            })
        })

        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
              { name = 'path' }
            }, {
              { name = 'cmdline' }
            }),
            matching = { disallow_symbol_nonprefix_matching = false }
        })

        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_snipmate").lazy_load()
    end
}
