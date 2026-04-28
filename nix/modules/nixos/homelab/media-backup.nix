{ config, pkgs, lib, ... }:

{
  systemd.services.media-services-backup = {
    description = "Backup media service configs";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "media-backup" ''
        STATE_DIR="/data/.state"
        BACKUP_DIR="/srv/backup/media-services"
        mkdir -p "$BACKUP_DIR"
        for svc in sonarr radarr lidarr readarr prowlarr bazarr jellyfin seerr qbittorrent; do
          if [ -d "$STATE_DIR/$svc" ]; then
            ${pkgs.rsync}/bin/rsync -a --delete "$STATE_DIR/$svc/" "$BACKUP_DIR/$svc/"
          fi
        done
      '';
    };
  };

  systemd.timers.media-services-backup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /srv/backup 0750 root root -"
    "d /srv/backup/media-services 0750 root root -"
  ];
}
