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
    };
  };

  environment.systemPackages = [ pkgs.headscale ];

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };
}
