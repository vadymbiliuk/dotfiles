{ config, pkgs, lib, ... }:

{
  services.mongodb = {
    enable = true;
    package = pkgs.mongodb-ce;
    dbpath = "/var/lib/mongodb";
    bind_ip = "0.0.0.0";
  };
}
