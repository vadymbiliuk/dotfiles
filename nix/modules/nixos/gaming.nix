{ config, pkgs, ... }:

{
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\\\${HOME}/.steam/root/compatibilitytools.d";
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
    RADV_PERFTEST = "gpl";
    DXVK_ASYNC = "1";
    PROTON_ENABLE_NVAPI = "1";
  };

  environment.systemPackages = with pkgs; [
    lutris
    heroic
    mangohud
    gamemode
    bottles
    wine
    winetricks
    protontricks
    protonup
  ];

  boot.kernelParams = [ "nvidia_drm.modeset=1" "nvidia_drm.fbdev=1" ];

  services.thermald.enable = true;
}
