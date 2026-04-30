{ config, pkgs, lib, ... }:

{
  services.crowdsec = {
    enable = true;

    settings = {
      general.api.server = {
        enable = true;
        listen_uri = "127.0.0.1:8180";
      };
      lapi.credentialsFile = "/var/lib/crowdsec/state/local_api_credentials.yaml";
    };

    hub.collections = [
      "crowdsecurity/nginx"
      "crowdsecurity/sshd"
      "crowdsecurity/http-cve"
      "crowdsecurity/linux"
    ];

    localConfig.acquisitions = [
      {
        source = "journalctl";
        journalctl_filter = [ "_SYSTEMD_UNIT=sshd.service" ];
        labels.type = "syslog";
      }
      {
        filenames = [ "/var/log/nginx/access.log" "/var/log/nginx/error.log" ];
        labels.type = "nginx";
      }
    ];
  };

  systemd.services.crowdsec.serviceConfig = {
    SupplementaryGroups = [ "systemd-journal" "nginx" ];
  };
}
