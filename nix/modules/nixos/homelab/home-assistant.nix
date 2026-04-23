{ config, pkgs, lib, ... }:

{
  services.home-assistant = {
    enable = true;
    openFirewall = false;

    extraComponents = [
      "default_config"
      "met"
      "esphome"
      "mqtt"
    ];

    config = {
      homeassistant = {
        name = "Home";
        unit_system = "metric";
        time_zone = "Europe/Kyiv";
      };
      http = {
        server_port = 8123;
        use_x_forwarded_for = true;
        trusted_proxies = [ "127.0.0.1" "::1" ];
      };
    };
  };

  services.nginx.virtualHosts."ha.zxxki.com" = {
    useACMEHost = "zxxki.com";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8123";
      proxyWebsockets = true;
      extraConfig = ''
        allow 127.0.0.1;
        allow 100.64.0.0/10;
        deny all;
      '';
    };
  };
}
