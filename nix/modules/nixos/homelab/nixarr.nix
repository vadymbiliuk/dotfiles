{ config, pkgs, lib, ... }:

let
  sqlite = "${pkgs.sqlite}/bin/sqlite3";

  seedDb = db: settings: ''
    COUNT=$(${sqlite} ${db} "SELECT COUNT(*) FROM DownloadClients;" 2>/dev/null || echo "0")
    if [ "$COUNT" = "0" ]; then
      ${sqlite} ${db} "
        INSERT INTO DownloadClients (Enable, Name, Implementation, ConfigContract, Settings, Priority)
        VALUES (1, 'Transmission', 'Transmission', 'TransmissionSettings', '${settings}', 1);" 2>/dev/null || true
    fi
  '';

  stateDir = "/data/.state/nixarr";

  setRssSyncInterval = db: ''
    HAS_RSS=$(${sqlite} ${db} "SELECT COUNT(*) FROM Config WHERE Key='rsssyncinterval';" 2>/dev/null || echo "0")
    if [ "$HAS_RSS" = "0" ]; then
      ${sqlite} ${db} "INSERT INTO Config (Key, Value) VALUES ('rsssyncinterval', '10');" 2>/dev/null || true
    else
      ${sqlite} ${db} "UPDATE Config SET Value='10' WHERE Key='rsssyncinterval';" 2>/dev/null || true
    fi
  '';

  fixJellyseerrSettings = pkgs.writeText "fix-seerr.py" ''
    import json, sys
    path = "${stateDir}/jellyseerr/settings.json"
    try:
      with open(path) as f:
        s = json.load(f)
      changed = False
      if s.get("jellyfin", {}).get("externalHostname") != "https://watch.zxxki.com":
        s.setdefault("jellyfin", {})["externalHostname"] = "https://watch.zxxki.com"
        changed = True
      if changed:
        with open(path, "w") as f:
          json.dump(s, f, indent=1)
    except Exception as e:
      print(f"Jellyseerr settings: {e}", file=sys.stderr)
  '';

  seedScript = pkgs.writeShellScript "nixarr-seed" ''
    ${seedDb "${stateDir}/sonarr/sonarr.db" ''{"host":"localhost","port":9091,"useSsl":false,"urlBase":"/transmission/rpc","username":"","password":"","tvCategory":"tv-sonarr","recentTvPriority":0,"olderTvPriority":0,"initialState":0,"addPaused":false}''}
    ${seedDb "${stateDir}/radarr/radarr.db" ''{"host":"localhost","port":9091,"useSsl":false,"urlBase":"/transmission/rpc","username":"","password":"","movieCategory":"radarr","recentMoviePriority":0,"olderMoviePriority":0,"initialState":0,"addPaused":false}''}
    ${seedDb "${stateDir}/lidarr/lidarr.db" ''{"host":"localhost","port":9091,"useSsl":false,"urlBase":"/transmission/rpc","username":"","password":"","musicCategory":"lidarr","recentMusicPriority":0,"olderMusicPriority":0,"initialState":0,"addPaused":false}''}
    ${seedDb "${stateDir}/readarr/readarr.db" ''{"host":"localhost","port":9091,"useSsl":false,"urlBase":"/transmission/rpc","username":"","password":"","bookCategory":"readarr","recentBookPriority":0,"olderBookPriority":0,"initialState":0,"addPaused":false}''}

    ${setRssSyncInterval "${stateDir}/sonarr/sonarr.db"}
    ${setRssSyncInterval "${stateDir}/radarr/radarr.db"}
    ${setRssSyncInterval "${stateDir}/lidarr/lidarr.db"}
    ${setRssSyncInterval "${stateDir}/readarr/readarr.db"}

    ${pkgs.python3}/bin/python3 ${fixJellyseerrSettings}
  '';
in
{
  systemd.services.nixarr-seed = {
    description = "Seed arr services with Transmission download client";
    after = [ "sonarr.service" "radarr.service" "lidarr.service" "readarr.service" "seerr.service" ];
    requires = [ "sonarr.service" "radarr.service" "lidarr.service" "readarr.service" "seerr.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = seedScript;
    };
  };

  systemd.tmpfiles.rules = [
    "d /srv/media/library/manga 0775 root media -"
  ];

  nixarr = {
    enable = true;
    mediaDir = "/srv/media";
    mediaUsers = [ "kavita" ];

    jellyfin = {
      enable = true;
      openFirewall = false;
    };

    seerr = {
      enable = true;
      openFirewall = false;
    };

    transmission = {
      enable = true;
      peerPort = 50000;
      openFirewall = false;
    };

    sonarr = {
      enable = true;
      openFirewall = false;
    };

    radarr = {
      enable = true;
      openFirewall = false;
    };

    lidarr = {
      enable = true;
      openFirewall = false;
    };

    readarr = {
      enable = true;
      openFirewall = false;
    };

    bazarr = {
      enable = true;
      openFirewall = false;
    };

    prowlarr = {
      enable = true;
      openFirewall = false;
    };
  };
}
