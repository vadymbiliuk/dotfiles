return {
    'nvim-tree/nvim-tree.lua',
    config = function()
        require('nvim-tree').setup({
            sort_by = "case_sensitive",
            respect_buf_cwd = true,
            sync_root_with_cwd = true,
            view = {
                width = 35,
                centralize_selection = true,
            },
            renderer = {
                group_empty = true,
            },
            git = {
                enable = true,
                ignore = false,
                timeout = 500,
            },
            filters = {
                dotfiles = false,
                custom = {
                    -- "^.git$",
                    -- "^.sl$",
                    "^.DS_Store",
                    -- "^target$",
                    -- "^node_modules$",
                },
            },
            ui = {
                confirm = {
                    remove = false,
                    trash = false,
                },
            },
            update_focused_file = {
                enable = true,
                update_root = true,
                ignore_list = {},
            },
        })
    end
}
