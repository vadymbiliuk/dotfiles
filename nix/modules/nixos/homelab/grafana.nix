{ config, pkgs, lib, ... }:

{
  services.grafana = {
    enable = true;

    settings = {
      server = {
        http_addr = "0.0.0.0";
        http_port = 3100;
      };

      security = {
        admin_user = "admin";
        secret_key = "$__file{/run/secrets/grafana-secret-key}";
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
}
