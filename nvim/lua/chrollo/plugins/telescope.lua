return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build =
            'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
        },
        { 'nvim-telescope/telescope-dap.nvim' },
        { 'nvim-telescope/telescope-ui-select.nvim' },
        {
            "nvim-telescope/telescope-file-browser.nvim",
            dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
        },
        { 'nvim-telescope/telescope-project.nvim' },
        { 'nvim-telescope/telescope-media-files.nvim' },
        { 'LukasPietzschmann/telescope-tabs' }
    },
    config = function()
        -- Setup telescope
        require('telescope').setup {
            extensions = {
                fzf = {
                    fuzzy = true,                   -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true,    -- override the file sorter
                    case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                },
                projects = {
                    base_dirs = {
                        { "~/Documents/Programming", max_depth = 2 },
                    }
                }
            },
            defaults = {
                file_ignore_patterns = { "node_modules" },
                prompt_prefix = "   ",
                selection_caret = "  ",
                entry_prefix = "  ",
                sorting_strategy = "ascending",
                layout_strategy = "flex",
                set_env = { COLORTERM = "truecolor" },
                dynamic_preview_title = true,
                layout_config = {
                    horizontal = { prompt_position = "top", preview_width = 0.55 },
                    vertical = { mirror = false },
                    width = 0.87,
                    height = 0.8,
                    preview_cutoff = 120
                },
            },
            pickers = {
                oldfiles = { prompt_title = "Recent files" }
            }
        }

        -- Load extensions
        require('telescope').load_extension('ui-select')
        require('telescope').load_extension('file_browser')
        require('telescope').load_extension('project')
        require('telescope').load_extension('telescope-tabs')
        require('telescope').load_extension('projects')

        if vim.fn.executable('ueberzug') == 1 then
            require('telescope').load_extension('media_files')
        end

        if vim.fn.executable('zoxide') == 1 then
            require('telescope').load_extension('zoxide')
        end
    end
}
