{ config, pkgs, lib, ... }:

{
  nixarr = {
    enable = true;
    mediaDir = "/srv/media";
    mediaUsers = [ "kavita" ];

    jellyfin = {
      enable = true;
      openFirewall = false;
    };

    jellyseerr = {
      enable = true;
      openFirewall = false;
    };

    transmission = {
      enable = true;
      peerPort = 50000;
      openFirewall = false;
    };

    sonarr = {
      enable = true;
      openFirewall = false;
    };

    radarr = {
      enable = true;
      openFirewall = false;
    };

    lidarr = {
      enable = true;
      openFirewall = false;
    };

    readarr = {
      enable = true;
      openFirewall = false;
    };

    bazarr = {
      enable = true;
      openFirewall = false;
    };

    prowlarr = {
      enable = true;
      openFirewall = false;
    };
  };
}
