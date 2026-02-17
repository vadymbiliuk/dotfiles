{ config, pkgs, lib, ... }:

{
  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      DOMAIN = "https://vault.zxxki.com";
      SIGNUPS_ALLOWED = false;
      INVITATIONS_ALLOWED = true;
      SHOW_PASSWORD_HINT = false;
      WEB_VAULT_ENABLED = true;
    };
    backupDir = "/var/backup/vaultwarden";
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/vaultwarden 0750 vaultwarden vaultwarden -"
  ];

  systemd.services.vaultwarden-backup = {
    description = "Backup Vaultwarden data";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.rsync}/bin/rsync -a ${config.services.vaultwarden.backupDir}/ /var/backup/vaultwarden-snapshots/$(date +%Y%m%d)/";
    };
  };

  systemd.timers.vaultwarden-backup = {
    description = "Daily Vaultwarden backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  environment.systemPackages = with pkgs; [ sqlite ];
}
