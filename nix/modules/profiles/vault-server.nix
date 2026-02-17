{ config, pkgs, lib, ... }:

{
  imports = [ ./server-base.nix ];

  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 8222;
      DOMAIN = lib.mkDefault "http://localhost:8222";
      SIGNUPS_ALLOWED = false;
      INVITATIONS_ALLOWED = true;
      SHOW_PASSWORD_HINT = false;
      WEB_VAULT_ENABLED = true;
    };
    backupDir = "/var/backup/vaultwarden";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."vault.local" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
        proxyWebsockets = true;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

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
