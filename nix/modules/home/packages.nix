{ config, pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  developmentPackages = with pkgs; [
    gcc
    lldb
    cmake
    gettext
    ffmpeg
    qemu
    postgresql_16
    redis
    postman
  ];

  lspPackages = with pkgs; [
    black
    prettierd
    nixfmt-classic
    ruff
    vscode-langservers-extracted
    haskellPackages.fourmolu
    stylish-haskell
    haskellPackages.hoogle
    ocamlPackages.ocaml-lsp
    ocamlPackages.ocamlformat
    emacsPackages.lsp-grammarly
    haskellPackages.cabal-fmt
    clang-tools
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
    tailwindcss-language-server
    eslint_d
    nil
    biome
    csslint
    lua-language-server
    hpack
    stylelint-lsp
    pre-commit
  ];

  programmingPackages = with pkgs; [
    jdk23
    luajitPackages.luarocks
    lua51Packages.lua
    cargo
    go
    poetry
    nodejs_22
    claude-code
  ];

  utilityPackages = with pkgs;
    [
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
    ] ++ lib.optionals isDarwin [ mkalias ];
in {
  home.packages = developmentPackages ++ lspPackages ++ programmingPackages
    ++ utilityPackages;
}
