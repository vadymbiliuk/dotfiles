{ config, pkgs, lib, ... }:

{
  services.headscale = {
    enable = true;
    address = "127.0.0.1";
    port = 8080;
    settings = {
      server_url = "https://vpn.zxxki.com";
      dns = {
        base_domain = "tail.zxxki.com";
        magic_dns = true;
        nameservers.global = [
          "192.168.0.190"
          "1.1.1.1"
        ];
      };
      prefixes = {
        v4 = "100.64.0.0/10";
        v6 = "fd7a:115c:a1e0::/48";
      };
      derp = {
        server = {
          enabled = false;
        };
        urls = [
          "https://controlplane.tailscale.com/derpmap/default"
        ];
      };
      logtail = {
        enabled = false;
      };
      log = {
        level = "info";
      };
      policy = {
        path = pkgs.writeText "headscale-acl.json" (builtins.toJSON {
          hosts = {
            "hashira" = "100.64.0.2";
          };
          groups = {
            "group:admin" = [ "zooki@" ];
            "group:family" = [ "family@" ];
            "group:friend" = [ "friend@" ];
          };
          acls = [
            { action = "accept"; src = [ "group:admin" ]; dst = [ "*:*" ]; }
            { action = "accept"; src = [ "group:family" ]; dst = [ "*:*" ]; }
            {
              action = "accept";
              src = [ "group:friend" ];
              dst = [
                "hashira:80"
                "hashira:443"
                "hashira:8096"
                "hashira:5055"
                "hashira:5000"
                "hashira:3300"
                "hashira:8222"
                "hashira:6167"
                "hashira:5672"
                "hashira:15672"
                "hashira:6379"
                "hashira:9092"
                "hashira:5432"
                "hashira:27017"
                "hashira:7474"
                "hashira:7687"
                "hashira:25565"
              ];
            }
          ];
        });
      };
    };
  };

  environment.systemPackages = [ pkgs.headscale ];

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };
}
