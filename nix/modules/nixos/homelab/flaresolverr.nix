{ config, pkgs, lib, ... }:

{
  services.flaresolverr = {
    enable = true;
    openFirewall = false;
  };
}
