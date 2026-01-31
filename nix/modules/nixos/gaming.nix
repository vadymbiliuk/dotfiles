{ pkgs, ... }:

{
  programs = {
    gamemode.enable = true;
    gamescope.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      extraPackages = with pkgs; [
        SDL2
        gamescope
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
