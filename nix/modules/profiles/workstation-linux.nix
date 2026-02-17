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
    unstable.claude-code
    teamspeak6-client
    (symlinkJoin {
      name = "tableplus-wrapped";
      paths = [ tableplus ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/tableplus \
          --set SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt"
      '';
    })
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
  };

  services.nordvpn.enable = true;
}
