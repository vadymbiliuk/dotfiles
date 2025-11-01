{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../modules/nixos/nix.nix
    ../modules/nixos/audio.nix
    ../modules/nixos/graphics.nix
    ../modules/nixos/gaming.nix
    ../modules/nixos/boot.nix
    ../modules/nixos/networking.nix
    ../modules/nixos/services.nix
    ../modules/nixos/virtualization.nix
    ../modules/nixos/lanzaboote.nix
    ../modules/nixos/system.nix
    ../modules/nixos/hyprland.nix
    ../modules/nixos/1password.nix
  ];

  networking.hostName = "minazuki";

  users.users.minazuki = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "networkmanager" "audio" "video" "docker" "libvirtd" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.minazuki = {
      imports = [
        ../modules/home/base.nix
        ../modules/home/wallpaper.nix
        ../modules/home/walker.nix
        ../modules/home/firefox.nix
        ../modules/home/packages.nix
        ../modules/home/hyprland.nix
        ../modules/home/waybar.nix
        ../modules/home/theme.nix
        ../modules/home/editors.nix
        ../modules/home/cursor.nix
        ../modules/home/noisetorch.nix
        ../modules/home/auto-english.nix
      ];
      
      programs.mangohud = {
        enable = true;
        settings = {
          cpu_stats = true;
          cpu_temp = true;
          cpu_power = true;
          gpu_stats = true;
          gpu_temp = true;
          gpu_power = true;
          ram = true;
          vram = true;
          fps = true;
          frametime = false;
          frame_timing = false;
          gamemode = true;
          vulkan_driver = false;
          wine = true;
          position = "top-left";
          font_size = 16;
          background_alpha = 0.3;
          offset_x = 0;
          offset_y = 0;
          no_display = false;
          toggle_hud = "Shift_R+F12";
          toggle_fps_limit = "Shift_L+F1";
          toggle_logging = "Shift_L+F2";
          reload_cfg = "Shift_L+F4";
          upload_log = "Shift_L+F3";
        };
      };
      
      home.enableNixpkgsReleaseCheck = false;
      home.stateVersion = "25.05";
    };
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    wl-clipboard

    waybar
    hyprpaper
    kdePackages.dolphin
    grim
    slurp
    gnome-calendar
    networkmanagerapplet

    telegram-desktop
    discord
    teamspeak3

    obs-studio
    obsidian
    pavucontrol
    blueman
    playerctl

    protonvpn-gui

    sbctl
    niv
    ghostty
    libnotify
  ];

}

