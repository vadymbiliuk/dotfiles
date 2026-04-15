{ config, pkgs, lib, ... }:

{
  services.lidarr = {
    enable = true;
    openFirewall = false;
  };

  users.users.lidarr.extraGroups = [ "media" ];
}
