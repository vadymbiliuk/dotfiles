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
    ../nixos/greetd.nix
    ../nixos/bitwarden.nix
    ../nixos/nordvpn.nix
    ../nixos/noctalia.nix
  ];

  programs.zsh.enable = true;

  fonts.packages = with pkgs; [ material-symbols ];

  environment.systemPackages = with pkgs; [
    wl-clipboard
    pcmanfm
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
    extraSpecialArgs = { inherit inputs; };
  };

  services.nordvpn.enable = true;
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;
}
