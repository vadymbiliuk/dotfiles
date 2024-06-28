return {
    'luukvbaal/statuscol.nvim',
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
        local builtin = require('statuscol.builtin')
        local c = require('statuscol.ffidef').C
        require('statuscol').setup {
            relculright = true,
            segments = {
                {
                    sign = {
                        namespace = { 'gitsigns' },
                        name = { '.*' },
                        maxwidth = 1,
                        colwidth = 1,
                        auto = false,
                    },
                    click = 'v:lua.ScSa',
                    condition = {
                        function(args)
                            -- only show if signcolumn is enabled
                            return args.sclnu
                        end,
                    },
                },
                {
                    sign = {
                        namespace = { 'diagnostic' },
                        maxwidth = 2,
                        colwidth = 1,
                        auto = false,
                    },
                    click = 'v:lua.ScSa',
                    condition = {
                        function(args)
                            -- only show if signcolumn is enabled
                            return args.sclnu
                        end,
                    },
                },
                { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
                -- {
                --     text = {
                --         -- Amazing foldcolumn
                --         -- https://github.com/kevinhwang91/nvim-ufo/issues/4
                --         function(args)
                --             local foldinfo = c.fold_info(args.wp, args.lnum)
                --             local foldinfo_next = c.fold_info(args.wp, args.lnum + 1)
                --             local level = foldinfo.level
                --             local foldstr = ' '
                --             local hl = '%#FoldCol' .. level .. '#'
                --             if level == 0 then
                --                 hl = '%#Normal#'
                --                 foldstr = ' '
                --                 return hl .. foldstr .. '%#Normal# '
                --             end
                --             if level > 8 then
                --                 hl = '%#FoldCol8#'
                --             end
                --             if foldinfo.lines ~= 0 then
                --                 foldstr = '▹'
                --             elseif args.lnum == foldinfo.start then
                --                 foldstr = '◠'
                --             elseif
                --                 foldinfo.level > foldinfo_next.level
                --                 or (
                --                     foldinfo_next.start == args.lnum + 1
                --                     and foldinfo_next.level == foldinfo.level
                --                 )
                --             then
                --                 foldstr = '◡'
                --             end
                --             return hl .. foldstr .. '%#Normal# '
                --         end,
                --     },
                --     click = 'v:lua.ScFa',
                --     condition = {
                --         function(args)
                --             return args.fold.width ~= 0
                --         end,
                --     },
                -- },
            },
        }
    end
}
