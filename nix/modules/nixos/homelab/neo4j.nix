{ config, pkgs, lib, ... }:

{
  services.neo4j = {
    enable = true;
    directories = {
      home = "/var/lib/neo4j";
      data = "/var/lib/neo4j/data";
    };
    http = {
      enable = true;
      listenAddress = "0.0.0.0:7474";
      advertisedAddress = "localhost:7474";
    };
    https = {
      enable = false;
    };
    bolt = {
      enable = true;
      listenAddress = "0.0.0.0:7687";
      advertisedAddress = "localhost:7687";
    };
  };
}
