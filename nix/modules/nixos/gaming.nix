{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (_: prev: {
      gamescope = prev.gamescope.overrideAttrs (_: {
        NIX_CFLAGS_COMPILE = [ "-fno-fast-math" ];
      });
    })
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = p: with p; [
        libxcursor
        libxi
        libxinerama
        libxscrnsaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.kernelParams = [
    "amd_pstate=active"
  ];

  boot.kernel.sysctl = {
    "kernel.sched_cfs_bandwidth_slice_us" = 3000;
    "net.ipv4.tcp_fin_timeout" = 5;
    "kernel.split_lock_mitigate" = 0;
    "vm.max_map_count" = 2147483642;
  };

  programs = {
    gamemode.enable = true;
    gamescope.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      extraPackages = with pkgs; [
        SDL2
        gamescope
        gamemode
        mangohud
      ];
      protontricks.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    lutris
    steam-run
    dxvk
    gamescope
    mangohud
    r2modman
    heroic
    bottles
    steamtinkerlaunch
    prismlauncher
  ];
}
