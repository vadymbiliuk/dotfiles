{ config, pkgs, lib, ... }:

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
        ];
      };

      nginx = {
        enable = true;
        port = 9113;
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
    ];
  };

  services.nginx.statusPage = true;
}
