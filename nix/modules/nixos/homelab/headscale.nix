{ config, pkgs, lib, ... }:

{
  services.headscale = {
    enable = true;
    address = "0.0.0.0";
    port = 8080;
    settings = {
      server_url = "https://vpn.zxxki.com";
      dns = {
        base_domain = "tail.zxxki.com";
        magic_dns = true;
        nameservers.global = [
          "1.1.1.1"
          "8.8.8.8"
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
    };
  };

  environment.systemPackages = [ pkgs.headscale ];

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };
}
