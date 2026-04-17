{ config, pkgs, lib, ... }:

{
  services.grafana = {
    enable = true;

    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3100;
        domain = "grafana.zxxki.com";
        root_url = "https://grafana.zxxki.com";
      };

      security = {
        admin_user = "admin";
        secret_key = "$__file{/run/secrets/grafana-secret-key}";
        cookie_secure = true;
      };

      analytics.reporting_enabled = false;
    };

    provision = {
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://127.0.0.1:9090";
          isDefault = true;
          access = "proxy";
        }
      ];
    };
  };

  services.nginx.virtualHosts."grafana.zxxki.com" = {
    useACMEHost = "zxxki.com";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3100";
      proxyWebsockets = true;
      extraConfig = ''
        allow 100.64.0.0/10;
        deny all;
      '';
    };
  };
}
