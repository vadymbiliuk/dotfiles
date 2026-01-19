{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  imports = [
    ./base.nix
    ../nixos/nix.nix
    ../nixos/audio.nix
    ../nixos/graphics.nix
    ../nixos/boot.nix
    ../nixos/networking.nix
    ../nixos/services.nix
    ../nixos/system.nix
    ../nixos/hyprland.nix
    ../nixos/bitwarden.nix
    ../nixos/nordvpn.nix
  ];

  programs.zsh.enable = true;

  fonts.packages = with pkgs; [ material-symbols ];

  environment.systemPackages = with pkgs; [
    wl-clipboard
    unstable.quickshell
    qt6.qt5compat
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtquickeffectmaker
    kdePackages.qt5compat
    kdePackages.dolphin
    hyprpaper
    grim
    slurp
    gnome-calendar
    networkmanagerapplet
    telegram-desktop
    unstable.discord
    thunderbird
    unstable.slack
    obs-studio
    unstable.obsidian
    pavucontrol
    blueman
    playerctl
    sbctl
    niv
    ghostty
    libnotify
    clamav
    unstable.claude-code
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  services.nordvpn.enable = true;
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;
}
