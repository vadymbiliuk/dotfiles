{ config, pkgs, ... }:
let
  packages = import (builtins.fetchGit {
    name = "my-old-revision";
    url = "https://github.com/NixOS/nixpkgs/";
    ref = "refs/heads/nixpkgs-unstable";
    rev = "e89cf1c932006531f454de7d652163a9a5c86668";
  }) { system = "aarch64-darwin"; };

  googleCloudSdk = packages.google-cloud-sdk-gce;
in {
  programs.home-manager.enable = true;

  home.username = "vadymbiliuk";
  home.homeDirectory = "/Users/vadymbiliuk";

  home.stateVersion = "24.05";

  programs = {
    zsh = import ./home/zsh.nix { inherit config pkgs; };
    git = import ./home/git.nix { inherit config pkgs; };
    starship = import ./home/starship.nix { inherit pkgs; };
  };

  home.packages = [
    pkgs.black
    pkgs.thefuck
    pkgs.prettierd
    pkgs.nixfmt-classic
    pkgs.ruff
    pkgs.vscode-langservers-extracted
    pkgs.haskellPackages.fourmolu
    pkgs.haskellPackages.hoogle
    pkgs.haskellPackages.fourmolu
    (googleCloudSdk.withExtraComponents [
      googleCloudSdk.components.app-engine-python
      googleCloudSdk.components.app-engine-python-extras
    ])
    pkgs.luajitPackages.luarocks
    pkgs.lua51Packages.lua
    pkgs.ocamlPackages.ocamlformat
    pkgs.haskellPackages.cabal-fmt
    pkgs.clang-tools
    pkgs.ruff
    pkgs.rustfmt
    pkgs.stylua
    pkgs.bash-language-server
    pkgs.dockerfile-language-server-nodejs
    pkgs.pyright
    pkgs.ruff-lsp
    pkgs.vim-language-server
    pkgs.yaml-language-server
    pkgs.vue-language-server
    pkgs.svelte-language-server
    pkgs.nodePackages_latest.graphql-language-service-cli
    pkgs.rust-analyzer
    pkgs.tailwindcss-language-server
    pkgs.nodePackages_latest.vscode-json-languageserver
    pkgs.eslint_d
    pkgs.nil
    pkgs.biome
    pkgs.csslint
    pkgs.lua-language-server
    pkgs.hpack
    pkgs.neovim
    pkgs.git
    pkgs.lazygit
    pkgs.tmux
    pkgs.kitty
    pkgs.obsidian
    pkgs.gnused
    pkgs.cargo
    pkgs.ripgrep
    pkgs.fzf
    pkgs.fd
    pkgs.pre-commit
    pkgs.stack
    pkgs.cabal-install
    pkgs.poetry
    pkgs.pyenv
    pkgs.nodejs_22
    pkgs.haskell-language-server
  ];
}
