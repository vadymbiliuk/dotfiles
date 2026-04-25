{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (_: prev: {
      gamescope = prev.gamescope.overrideAttrs (_: {
        NIX_CFLAGS_COMPILE = [ "-fno-fast-math" ];
      });
    })
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
  };

  programs = {
    gamemode.enable = true;
    gamescope.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
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
