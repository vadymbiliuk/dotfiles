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
    ./hardware-configuration.nix
    ../modules/nixos/lanzaboote.nix
    ../modules/profiles/workstation-linux.nix
    ../modules/profiles/gaming.nix
  ];

  networking.hostName = "shinzou";

  services.tailscale.enable = true;

  users.users.zooki = {
    isNormalUser = true;
    uid = 1000;
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

  home-manager.users.zooki = {
    imports = [
      ../modules/home/base.nix
      ../modules/home/wallpaper.nix
      ../modules/home/rofi.nix
      ../modules/home/firefox.nix
      ../modules/home/packages.nix
      ../modules/home/hyprland.nix
      ../modules/home/theme.nix
      ../modules/home/cursor.nix
      ../modules/home/auto-english.nix
      ../modules/home/noctalia.nix
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

    home.packages = [ unstable.opencode ];

    home.enableNixpkgsReleaseCheck = false;
    home.stateVersion = "25.05";
  };
}
