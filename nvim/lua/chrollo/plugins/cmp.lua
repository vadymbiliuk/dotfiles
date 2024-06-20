return {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'f3fora/cmp-spell' },
        { 'hrsh7th/cmp-cmdline' },
        { 'hrsh7th/cmp-path' },
        { 'saadparwaiz1/cmp_luasnip' },
        { 'hrsh7th/cmp-nvim-lua' },
        { 'hrsh7th/cmp-omni' },
        { 'onsails/lspkind-nvim' },
    },
    config = function()
        local cmp = require('cmp')
        local lspkind = require('lspkind')

        local escape_next = function()
            local current_line = vim.api.nvim_get_current_line()
            local _, col = unpack(vim.api.nvim_win_get_cursor(0))
            local next_char = string.sub(current_line, col + 1, col + 1)
            return next_char == ')'
                or next_char == '"'
                or next_char == "'"
                or next_char == '`'
                or next_char == ']'
                or next_char == '}'
        end

        local move_right = function()
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))
            vim.api.nvim_win_set_cursor(0, { row, col + 1 })
        end

        local is_in_bullet = function()
            local line = vim.api.nvim_get_current_line()
            return line:match('^%s*(.-)%s*$') == '-'
                and (vim.bo.filetype == 'markdown' or vim.bo.filetype == 'text')
        end

        -- supertab functionality
        local luasnip = require('luasnip')
        local function ins_tab_mapping(fallback)
            local entry = cmp.get_selected_entry()
            if
                cmp.visible()
                -- if tabbing on an entry that already matches what we have, just
                -- skip and fall through to the next action
                and not (
                    entry.source.name == 'spell'
                    and entry.context.cursor_before_line:match(
                        '^' .. entry:get_word() .. '$'
                    )
                )
            then
                cmp.confirm { select = true }
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif escape_next() then
                move_right()
            elseif is_in_bullet() then
                vim.cmd.BulletDemote()
                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                vim.api.nvim_win_set_cursor(0, { row, col + 1 })
            else
                fallback()
            end
        end

        local function ins_s_tab_mapping(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            elseif cmp.visible() then
                cmp.select_prev_item()
            elseif is_in_bullet() then
                vim.cmd.BulletPromote()
                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                vim.api.nvim_win_set_cursor(0, { row, col + 1 })
            else
                fallback()
            end
        end

        local cmp_mappings = {
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
        }

        local BORDER_STYLE = require('chrollo.config.settings').border
        local in_ts_cap = require('cmp.config.context').in_treesitter_capture
        local in_jsx = require('chrollo.config.settings').in_jsx_tags
        local kinds = require('cmp.types').lsp.CompletionItemKind
        local compare = require('cmp.config.compare')

        local cmp_info_style = cmp.config.window.bordered {
            border = BORDER_STYLE,
        }
        -- pumheight doesn't affect the documentation window
        cmp_info_style.max_height = 16

        local cmp_config = {
            mapping = cmp_mappings,
            completion = {
                completeopt = 'menu,menuone,noinsert',
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            sources = {
                { name = 'path' },
                { name = 'nvim_lua', ft = 'lua' },
                {
                    name = 'nvim_lsp',
                    entry_filter = function(entry, _)
                        -- filter out most text entries from LSP suggestions
                        local keep_text_entries = { 'emmet_language_server', 'marksman' }
                        local client_name = entry.source.source.client
                            and entry.source.source.client.name
                            or ''
                        local ft = vim.bo.filetype
                        if
                            client_name == 'emmet_language_server'
                            and (ft == 'javascriptreact' or ft == 'typescriptreact')
                        then
                            return in_jsx(true)
                        end
                        return kinds[entry:get_kind()] ~= 'Text'
                            or vim.tbl_contains(keep_text_entries, client_name)
                    end,
                },
                { name = 'luasnip' },
                {
                    name = 'spell',
                    keyword_length = 3,
                    -- help filter out the unhelpful words
                    max_item_count = 1,
                    entry_filter = function(entry, _)
                        return not entry:get_completion_item().label:find(' ')
                    end,
                    option = {
                        keep_all_entries = true,
                        enable_in_context = function()
                            return not in_ts_cap('nospell')
                        end,
                    },
                },
                { name = 'omni' },
            },
            formatting = {
                fields = { 'abbr', 'menu', 'kind' },
                format = lspkind.cmp_format {
                    mode = 'symbol_text',
                    -- The function below will be called before any actual modifications
                    -- from lspkind so that you can provide more controls on popup
                    -- customization.
                    -- (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                    before = function(_, vim_item)
                        -- set max width of cmp window
                        local width = 30
                        local ellipses_char = '…'
                        local label = vim_item.abbr
                        local truncated_label = vim.fn.strcharpart(label, 0, width)
                        if truncated_label ~= label then
                            vim_item.abbr = truncated_label .. ellipses_char
                        else
                            vim_item.abbr = label .. ' '
                        end
                        return vim_item
                    end,
                    menu = {
                        spell = '[Dict]',
                        nvim_lsp = '[LSP]',
                        nvim_lua = '[API]',
                        path = '[Path]',
                        luasnip = '[Snip]',
                    },
                },
            },
            window = {
                completion = cmp_info_style,
                documentation = cmp_info_style,
            },
            sorting = {
                priority_weight = 2,
                comparators = {
                    -- custom comparator for making spell sources work.
                    -- (basically compare.order but for spell source only)
                    function(a, b)
                        if a.source.name ~= 'spell' or b.source.name ~= 'spell' then
                            return nil
                        end
                        local diff = a.id - b.id
                        if diff < 0 then
                            return true
                        elseif diff > 0 then
                            return false
                        end
                        return nil
                    end,
                    compare.offset,
                    compare.exact,
                    compare.score,
                    compare.recently_used,
                    compare.locality,
                    compare.kind,
                    compare.length,
                    compare.order,
                },
            },
            experimental = {
                ghost_text = true,
            },
        }

        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true

        -- Insert `(` after select function or method item
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

        -- `:` cmdline setup.
        cmp.setup.cmdline(':', {
            mapping = cmp_mappings,
            sources = cmp.config.sources({
                { name = 'path' },
            }, {
                {
                    name = 'cmdline',
                    keyword_length = 3,
                    option = {
                        ignore_cmds = { 'Man', '!' },
                    },
                },
            }),
        })
        cmp.setup(cmp_config)
    end,
}
