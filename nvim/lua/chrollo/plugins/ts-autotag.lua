return {
    {
        'windwp/nvim-ts-autotag',
        ft = {
            'html',
            'xml',
            'javascript',
            'typescript',
            'javascriptreact',
            'typescriptreact',
            'svelte',
            'vue',
            'tsx',
            'jsx',
            'rescript',
            'php',
            'glimmer',
            'handlebars',
            'hbs',
            'markdown',
        },
        -- disabled here because I have it overridden somewhere else in order to
        -- achieve compatibility with luasnip
        opts = { enable_close_on_slash = false },
    } }
