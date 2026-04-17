{ config, pkgs, lib, ... }:

let
  readSecret = path: "$__file{${path}}";
in
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
        secret_key = readSecret "/run/secrets/grafana-secret-key";
        cookie_secure = true;
      };

      analytics.reporting_enabled = false;

      "unified_alerting".enabled = true;
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

      alerting = {
        contactPoints.settings = {
          contactPoints = [
            {
              name = "discord";
              receivers = [
                {
                  uid = "discord1";
                  type = "discord";
                  settings = {
                    url = readSecret "/run/secrets/grafana-discord-webhook";
                    title = ''{{ template "default.title" . }}'';
                    message = ''{{ template "default.message" . }}'';
                  };
                }
              ];
            }
            {
              name = "telegram";
              receivers = [
                {
                  uid = "telegram1";
                  type = "telegram";
                  settings = {
                    bottoken = readSecret "/run/secrets/grafana-telegram-token";
                    chatid = "133081420";
                    parse_mode = "HTML";
                  };
                }
              ];
            }
          ];
        };

        policies.settings = {
          policies = [
            {
              receiver = "discord";
              group_by = [ "alertname" ];
              group_wait = "30s";
              group_interval = "5m";
              repeat_interval = "4h";
              routes = [
                {
                  receiver = "telegram";
                  continue = true;
                }
              ];
            }
          ];
        };

        rules.settings = {
          groups = [
            {
              orgId = 1;
              name = "system";
              folder = "alerts";
              interval = "1m";
              rules = [
                {
                  uid = "disk-usage-high";
                  title = "Disk usage > 90%";
                  condition = "C";
                  for = "5m";
                  data = [
                    {
                      refId = "A";
                      relativeTimeRange = { from = 600; to = 0; };
                      datasourceUid = "PBFA97CFB590B2093";
                      model = {
                        expr = ''100 - ((node_filesystem_avail_bytes{mountpoint="/",fstype!="rootfs"} * 100) / node_filesystem_size_bytes{mountpoint="/",fstype!="rootfs"})'';
                        refId = "A";
                      };
                    }
                    {
                      refId = "C";
                      relativeTimeRange = { from = 600; to = 0; };
                      datasourceUid = "__expr__";
                      model = {
                        type = "threshold";
                        expression = "A";
                        conditions = [
                          {
                            evaluator = { type = "gt"; params = [ 90 ]; };
                            operator = { type = "and"; };
                            reducer = { type = "last"; };
                          }
                        ];
                        refId = "C";
                      };
                    }
                  ];
                  labels = { severity = "warning"; };
                  annotations = {
                    summary = "Disk usage is above 90%";
                    description = "Current disk usage: {{ $values.A }}%";
                  };
                }
                {
                  uid = "fail2ban-new-bans";
                  title = "New fail2ban bans detected";
                  condition = "C";
                  for = "0s";
                  data = [
                    {
                      refId = "A";
                      relativeTimeRange = { from = 300; to = 0; };
                      datasourceUid = "PBFA97CFB590B2093";
                      model = {
                        expr = ''increase(fail2ban_banned_total{type="total"}[5m])'';
                        refId = "A";
                      };
                    }
                    {
                      refId = "C";
                      relativeTimeRange = { from = 300; to = 0; };
                      datasourceUid = "__expr__";
                      model = {
                        type = "threshold";
                        expression = "A";
                        conditions = [
                          {
                            evaluator = { type = "gt"; params = [ 0 ]; };
                            operator = { type = "and"; };
                            reducer = { type = "last"; };
                          }
                        ];
                        refId = "C";
                      };
                    }
                  ];
                  labels = { severity = "info"; };
                  annotations = {
                    summary = "New IP banned by fail2ban";
                    description = "fail2ban has banned new IPs in the last 5 minutes";
                  };
                }
              ];
            }
          ];
        };
      };
    };
  };

  services.nginx.virtualHosts."grafana.zxxki.com" = {
    useACMEHost = "zxxki.com";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3100";
      proxyWebsockets = true;
      extraConfig = ''
        allow 127.0.0.1;
        allow 100.64.0.0/10;
        deny all;
      '';
    };
  };
}
