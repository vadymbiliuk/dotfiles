{ config, pkgs, lib, ... }:

{
  services.sonarr = {
    enable = true;
    openFirewall = false;
  };

  users.users.sonarr.extraGroups = [ "media" ];
}
