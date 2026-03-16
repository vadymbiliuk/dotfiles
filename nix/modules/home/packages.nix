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
      heroku
    ] ++ lib.optionals isLinux [ qemu ];

  lspPackages = with pkgs;
    [
      haskellPackages.hoogle
      emacsPackages.lsp-grammarly
      vue-language-server
      hpack
      pre-commit
      typos
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
    ] ++ lib.optionals isDarwin [ mkalias ]
    ++ lib.optionals isLinux [ pamixer brightnessctl woeusb sops age ssh-to-age foliate glib ];
in {
  home.packages = developmentPackages ++ lspPackages ++ programmingPackages
    ++ utilityPackages;
}
