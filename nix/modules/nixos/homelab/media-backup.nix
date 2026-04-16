{ config, pkgs, lib, ... }:

{
  systemd.services.media-services-backup = {
    description = "Backup media service configs";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "media-backup" ''
        BACKUP_DIR="/srv/backup/media-services"
        mkdir -p "$BACKUP_DIR"
        ${pkgs.rsync}/bin/rsync -a --delete /var/lib/jellyfin/ "$BACKUP_DIR/jellyfin/"
        ${pkgs.rsync}/bin/rsync -a --delete /var/lib/sonarr/ "$BACKUP_DIR/sonarr/"
        ${pkgs.rsync}/bin/rsync -a --delete /var/lib/radarr/ "$BACKUP_DIR/radarr/"
        ${pkgs.rsync}/bin/rsync -a --delete /var/lib/lidarr/ "$BACKUP_DIR/lidarr/"
        ${pkgs.rsync}/bin/rsync -a --delete /var/lib/readarr/ "$BACKUP_DIR/readarr/"
        ${pkgs.rsync}/bin/rsync -a --delete /var/lib/bazarr/ "$BACKUP_DIR/bazarr/"
        ${pkgs.rsync}/bin/rsync -a --delete /var/lib/prowlarr/ "$BACKUP_DIR/prowlarr/"
        ${pkgs.rsync}/bin/rsync -a --delete /var/lib/qbittorrent/ "$BACKUP_DIR/qbittorrent/"
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
