{ config, pkgs, lib, ... }:

{
  services.bazarr = {
    enable = true;
    openFirewall = false;
  };

  users.users.bazarr.extraGroups = [ "media" ];
}
