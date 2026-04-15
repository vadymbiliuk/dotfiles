{ config, pkgs, lib, ... }:

{
  services.crowdsec = {
    enable = true;

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

  systemd.services.crowdsec-setup = {
    description = "CrowdSec initial collection setup";
    wantedBy = [ "crowdsec.service" ];
    before = [ "crowdsec.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    path = [ config.services.crowdsec.package ];
    script = ''
      cscli collections install crowdsecurity/nginx --error || true
      cscli collections install crowdsecurity/sshd --error || true
      cscli collections install crowdsecurity/http-cve --error || true
      cscli collections install crowdsecurity/linux --error || true
    '';
  };

  environment.systemPackages = [ config.services.crowdsec.package ];
}
