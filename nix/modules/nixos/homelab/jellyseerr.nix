{ config, pkgs, lib, ... }:

{
  services.jellyseerr = {
    enable = true;
    openFirewall = false;
  };
}
