{ config, pkgs, lib, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };

  plugins = with unstable.vimPlugins; [
    claudecode-nvim
    copilot-vim
    plenary-nvim
    nvim-web-devicons

    lackluster-nvim

    nvim-lspconfig
    lspsaga-nvim
    conform-nvim
    nvim-vtsls
    haskell-tools-nvim

    blink-cmp
    friendly-snippets

    nvim-treesitter.withAllGrammars
    nvim-treesitter-context
    nvim-ts-autotag

    flash-nvim
    which-key-nvim
    oil-nvim
    harpoon2
    vim-visual-multi
    inputs.fff-nvim.packages.${pkgs.stdenv.hostPlatform.system}.fff-nvim

    vim-sleuth
    nvim-surround
    mini-move
    nvim-autopairs
    nvim-spectre
    comment-nvim

    lualine-nvim
    gitsigns-nvim
    statuscol-nvim
    indent-blankline-nvim
    vim-illuminate
    noice-nvim
    nui-nvim
    nvim-notify
    toggleterm-nvim
    edgy-nvim
    trouble-nvim
    mini-diff
    actions-preview-nvim
    snacks-nvim
    sidekick-nvim

    neotest
    neotest-jest
    neotest-vitest
    neotest-python
    neotest-rspec
    nvim-nio
    FixCursorHold-nvim

    nvim-dap
    nvim-dap-ui
    nvim-dap-virtual-text

    obsidian-nvim
    markdown-preview-nvim
    persistence-nvim
    direnv-vim
  ];

  pluginRtp = lib.concatMapStringsSep "\n" (p:
    ''vim.opt.runtimepath:prepend("${p}")''
  ) plugins;

  luaDir = ./lua/nvee;
in
{
  xdg.configFile."nvim/lua/nvee".source = luaDir;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    withRuby = false;

    initLua = ''
      ${pluginRtp}
      require("nvee.settings").setup()
      require("nvee.plugins")
      require("nvee.autocmd").setup()
    '';

    extraPackages = with unstable; [
      vtsls
      bash-language-server
      pyright
      ruff
      vim-language-server
      yaml-language-server
      svelte-language-server
      graphql-language-service-cli
      rust-analyzer
      lua-language-server
      nil
      biome
      vscode-langservers-extracted
      stylelint-lsp
      solargraph
      elmPackages.elm-language-server
      emmet-language-server

      black
      prettierd
      nixfmt
      rustfmt
      stylua
      yamlfmt
      ocamlPackages.ocamlformat
      haskellPackages.fourmolu
      stylish-haskell
      haskellPackages.cabal-fmt
      eslint_d
      rubocop
      rubyPackages.standard
      rubyPackages.erb-formatter
      fixjson
      clang-tools
      elmPackages.elm
      elmPackages.elm-format
      elmPackages.elm-review

      ripgrep
      fd
      lazygit
    ];
  };
}
