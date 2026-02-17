{ config, pkgs, lib, ... }:

{
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    openFirewall = false;
    port = 3000;
    settings = {
      http = {
        address = "127.0.0.1:3000";
      };
      dns = {
        bind_hosts = [ "0.0.0.0" ];
        port = 53;
        bootstrap_dns = [
          "1.1.1.1"
          "8.8.8.8"
        ];
        upstream_dns = [
          "https://dns.cloudflare.com/dns-query"
          "https://dns.google/dns-query"
        ];
        protection_enabled = true;
        filtering_enabled = true;
      };
      filtering = {
        rewrites = [ ];
      };
      filters = [
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
          name = "AdGuard DNS filter";
          id = 1;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt";
          name = "AdAway Default Blocklist";
          id = 2;
        }
      ];
    };
  };

  systemd.services.adguardhome.serviceConfig = {
    AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
  };
}
