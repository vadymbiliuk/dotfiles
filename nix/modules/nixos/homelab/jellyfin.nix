{ config, pkgs, lib, ... }:

{
  services.jellyfin = {
    enable = true;
    openFirewall = false;
  };

  users.users.jellyfin.extraGroups = [ "media" ];
}
