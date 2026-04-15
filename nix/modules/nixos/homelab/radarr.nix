{ config, pkgs, lib, ... }:

{
  services.radarr = {
    enable = true;
    openFirewall = false;
  };

  users.users.radarr.extraGroups = [ "media" ];
}
