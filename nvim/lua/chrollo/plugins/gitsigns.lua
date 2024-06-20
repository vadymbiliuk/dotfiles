local BORDER_STYLE = require('chrollo.config.settings').border

return {
    {
        'lewis6991/gitsigns.nvim',
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        config = function()
            require('gitsigns').setup {
                attach_to_untracked = true,
                signs = {
                    add = { text = '┃' },
                    change = { text = '┃' },
                    delete = { text = '•' },
                },
                signs_staged = {
                    add = { text = '┃' },
                    change = { text = '┃' },
                    delete = { text = '•' },
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
                    map({ 'n', 'x' }, '<leader>gj', function()
                        if vim.wo.diff then
                            return ']c'
                        end
                        vim.schedule(function()
                            gs.next_hunk()
                        end)
                        return '<Ignore>'
                    end, { expr = true })

                    map({ 'n', 'x' }, '<leader>gk', function()
                        if vim.wo.diff then
                            return '[c'
                        end
                        vim.schedule(function()
                            gs.prev_hunk()
                        end)
                        return '<Ignore>'
                    end, { expr = true })

                    -- git preview
                    map('n', '<leader>gp', gs.preview_hunk)
                    -- git blame
                    map('n', '<leader>gb', function()
                        gs.blame_line { full = true }
                    end)
                    -- undo git change
                    map('n', '<leader>gu', gs.reset_hunk)
                    map('x', '<leader>gu', function()
                        gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
                    end)
                    -- undo all git changes
                    map('n', '<leader>gr', gs.reset_buffer)
                    -- stage git changes
                    map('n', '<leader>ga', gs.stage_hunk)
                    map('x', '<leader>ga', function()
                        gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') }
                    end)
                    -- unstage git changes
                    map('n', '<leader>gU', gs.undo_stage_hunk)
                end,
            }
        end,
    } }
