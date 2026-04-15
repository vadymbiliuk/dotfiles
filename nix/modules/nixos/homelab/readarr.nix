{ config, pkgs, lib, ... }:

{
  services.readarr = {
    enable = true;
    openFirewall = false;
  };

  users.users.readarr.extraGroups = [ "media" ];
}
