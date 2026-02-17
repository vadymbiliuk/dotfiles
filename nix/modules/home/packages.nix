{ config, pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  developmentPackages = with pkgs;
    [
      gcc
      lldb
      cmake
      gettext
      ffmpeg
      postgresql_16
      redis
      bruno
    ] ++ lib.optionals isLinux [ qemu ];

  lspPackages = with pkgs;
    [
      vtsls
      black
      prettierd
      nixfmt
      ruff
      vscode-langservers-extracted
      haskellPackages.fourmolu
      stylish-haskell
      haskellPackages.hoogle
      ocamlPackages.ocaml-lsp
      ocamlPackages.ocamlformat
      emacsPackages.lsp-grammarly
      haskellPackages.cabal-fmt
      rustfmt
      stylua
      bash-language-server
      pyright
      vim-language-server
      yaml-language-server
      yamlfmt
      vue-language-server
      svelte-language-server
      rust-analyzer
      eslint_d
      nil
      biome
      lua-language-server
      hpack
      stylelint-lsp
      pre-commit
      solargraph
      rubocop
      rubyPackages.standard
      rubyPackages.erb-formatter
      nodePackages.fixjson
      typos
      clang-tools
    ];

  programmingPackages = with pkgs; [
    jdk21
    luajitPackages.luarocks
    lua51Packages.lua
    cargo
    go
    poetry
    nodejs_22
    bundler
  ];

  utilityPackages = with pkgs;
    [
      just
      tree-sitter
      (tree-sitter.withPlugins (p:
        with p; [
          tree-sitter-bash
          tree-sitter-c
          tree-sitter-cpp
          tree-sitter-css
          tree-sitter-dockerfile
          tree-sitter-go
          tree-sitter-haskell
          tree-sitter-html
          tree-sitter-javascript
          tree-sitter-json
          tree-sitter-lua
          tree-sitter-markdown
          tree-sitter-nix
          tree-sitter-ocaml
          tree-sitter-python
          tree-sitter-rust
          tree-sitter-toml
          tree-sitter-typescript
          tree-sitter-vim
          tree-sitter-yaml
        ]))
    ] ++ lib.optionals isDarwin [ mkalias ]
    ++ lib.optionals isLinux [ pamixer brightnessctl woeusb sops age ssh-to-age foliate glib ];
in {
  home.packages = developmentPackages ++ lspPackages ++ programmingPackages
    ++ utilityPackages;
}
