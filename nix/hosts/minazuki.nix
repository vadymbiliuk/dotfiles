{ config, pkgs, lib, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };

in {
  imports = [
    ./hardware-configuration.nix
    ../modules/nixos/nix.nix
    ../modules/nixos/audio.nix
    ../modules/nixos/graphics.nix
    ../modules/nixos/gaming.nix
    ../modules/nixos/boot.nix
    ../modules/nixos/networking.nix
    ../modules/nixos/services.nix
    ../modules/nixos/lanzaboote.nix
    ../modules/nixos/system.nix
    ../modules/nixos/hyprland.nix
    ../modules/nixos/1password.nix
    ../modules/nixos/nordvpn.nix
    # ../modules/nixos/drata-agent.nix
  ];

  networking.hostName = "nixos";

  users.users.minazuki = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "docker"
      "libvirtd"
      "nordvpn"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  fonts.packages = with pkgs; [ material-symbols ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.minazuki = {
      imports = [
        ../modules/home/base.nix
        ../modules/home/wallpaper.nix
        ../modules/home/rofi.nix
        ../modules/home/firefox.nix
        ../modules/home/packages.nix
        ../modules/home/hyprland.nix
        ../modules/home/hyprlock.nix
        ../modules/home/hypridle.nix
        ../modules/home/quickshell.nix
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
          ram = false;
          vram = false;
          fps = true;
          frametime = false;
          frame_timing = true;
          fps_limit_method = "late";
          histogram = true;
          gamemode = true;
          vulkan_driver = false;
          wine = true;
          position = "top-left";
          font_size = 14;
          background_alpha = 0;
          offset_x = -10;
          offset_y = -10;
          no_display = false;
          toggle_hud = "Shift_R+F12";
          toggle_fps_limit = "Shift_L+F1";
          toggle_logging = "Shift_L+F2";
          reload_cfg = "Shift_L+F4";
          upload_log = "Shift_L+F3";
          gpu_load_change = false;
          cpu_load_change = false;
          core_load_change = false;
          gpu_mem_clock = false;
          gpu_core_clock = false;
          cpu_mhz = false;
          table_columns = 6;
          width = 280;
          histogram_size = 80;
          height = 100;
          cellpadding_y = 0;
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

    unstable.quickshell
    qt6.qt5compat
    qt5.qtgraphicaleffects
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtquickeffectmaker
    kdePackages.qt5compat
    hyprpaper
    kdePackages.dolphin
    grim
    slurp
    gnome-calendar
    networkmanagerapplet

    telegram-desktop
    discord
    teamspeak3
    thunderbird
    slack

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
    clamav
  ];

  services.nordvpn.enable = true;
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;

}

