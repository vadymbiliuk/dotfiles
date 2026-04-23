{ config, pkgs, lib, ... }:

let
  fail2banCollector = pkgs.writeShellScript "fail2ban-collector" ''
    OUTPUT="/var/lib/prometheus-node-exporter/fail2ban.prom"
    TMP="$OUTPUT.tmp"

    echo "# HELP fail2ban_banned_total Total number of currently banned IPs" > "$TMP"
    echo "# TYPE fail2ban_banned_total gauge" >> "$TMP"

    ${pkgs.fail2ban}/bin/fail2ban-client status 2>/dev/null | grep "Jail list" | sed 's/.*://;s/,/\n/g' | while read -r jail; do
      jail=$(echo "$jail" | xargs)
      [ -z "$jail" ] && continue
      banned=$(${pkgs.fail2ban}/bin/fail2ban-client status "$jail" 2>/dev/null | grep "Currently banned" | awk '{print $NF}')
      total=$(${pkgs.fail2ban}/bin/fail2ban-client status "$jail" 2>/dev/null | grep "Total banned" | awk '{print $NF}')
      echo "fail2ban_banned_total{jail=\"$jail\",type=\"current\"} ''${banned:-0}" >> "$TMP"
      echo "fail2ban_banned_total{jail=\"$jail\",type=\"total\"} ''${total:-0}" >> "$TMP"
    done

    mv "$TMP" "$OUTPUT"
  '';
in
{
  services.prometheus = {
    enable = true;
    port = 9090;
    retentionTime = "30d";

    exporters = {
      node = {
        enable = true;
        port = 9100;
        enabledCollectors = [
          "systemd"
          "processes"
          "conntrack"
          "diskstats"
          "filesystem"
          "meminfo"
          "netdev"
          "netstat"
          "cpu"
          "loadavg"
          "textfile"
        ];
        extraFlags = [
          "--collector.textfile.directory=/var/lib/prometheus-node-exporter"
        ];
      };

      nginx = {
        enable = true;
        port = 9113;
      };

      postgres = {
        enable = true;
        port = 9187;
        runAsLocalSuperUser = true;
      };

      mongodb = {
        enable = true;
        port = 9216;
        collectAll = true;
      };
    };

    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [{
          targets = [ "127.0.0.1:9100" ];
        }];
        scrape_interval = "15s";
      }
      {
        job_name = "nginx";
        static_configs = [{
          targets = [ "127.0.0.1:9113" ];
        }];
        scrape_interval = "15s";
      }
      {
        job_name = "prometheus";
        static_configs = [{
          targets = [ "127.0.0.1:9090" ];
        }];
        scrape_interval = "30s";
      }
      {
        job_name = "postgresql";
        static_configs = [{
          targets = [ "127.0.0.1:9187" ];
        }];
        scrape_interval = "15s";
      }
      {
        job_name = "mongodb";
        static_configs = [{
          targets = [ "127.0.0.1:9216" ];
        }];
        scrape_interval = "15s";
      }
{
        job_name = "crowdsec";
        static_configs = [{
          targets = [ "127.0.0.1:6060" ];
        }];
        scrape_interval = "30s";
      }
      {
        job_name = "redis";
        static_configs = [{
          targets = [ "127.0.0.1:9121" ];
        }];
        scrape_interval = "15s";
      }
    ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/prometheus-node-exporter 0755 root root -"
  ];

  systemd.services.fail2ban-collector = {
    description = "Collect fail2ban metrics for Prometheus";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = fail2banCollector;
    };
  };

  systemd.timers.fail2ban-collector = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:*:0/30";
      Persistent = true;
    };
  };

  services.nginx.statusPage = true;
}
