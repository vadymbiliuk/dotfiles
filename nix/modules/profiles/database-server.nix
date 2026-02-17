{ config, pkgs, lib, ... }:

{
  imports = [ ./server-base.nix ];

  services.postgresql = {
    enable = lib.mkDefault false;
    enableTCPIP = lib.mkDefault false;
  };

  services.mysql = {
    enable = lib.mkDefault false;
    package = lib.mkDefault pkgs.mariadb;
  };

  services.redis.servers."" = { enable = lib.mkDefault false; };
}
