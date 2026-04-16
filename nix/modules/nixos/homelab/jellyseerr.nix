{ config, pkgs, lib, ... }:

{
  services.seerr = {
    enable = true;
    openFirewall = false;
  };
}
