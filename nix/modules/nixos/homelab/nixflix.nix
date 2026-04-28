{ config, pkgs, lib, ... }:

{
  sops.secrets.sonarr-api-key = {};
  sops.secrets.radarr-api-key = {};
  sops.secrets.lidarr-api-key = {};
  sops.secrets.prowlarr-api-key = {};
  sops.secrets.jellyfin-api-key = {};
  sops.secrets.seerr-api-key = {};
  sops.secrets.jellyfin-admin-password = {};
  sops.secrets.qbittorrent-password = {};

  nixflix = {
    enable = true;
    stateDir = "/data/.state";
    mediaDir = "/srv/media/library";
    downloadsDir = "/srv/media/torrents";

    jellyfin = {
      enable = true;
      openFirewall = false;
      apiKey = { _secret = config.sops.secrets.jellyfin-api-key.path; };

      users.admin = {
        password = { _secret = config.sops.secrets.jellyfin-admin-password.path; };
        policy.isAdministrator = true;
      };

      libraries = {
        Movies = {
          collectionType = "movies";
          paths = [ "/srv/media/library/movies" ];
        };
        Shows = {
          collectionType = "tvshows";
          paths = [ "/srv/media/library/shows" ];
        };
        Music = {
          collectionType = "music";
          paths = [ "/srv/media/library/music" ];
        };
      };
    };

    seerr = {
      enable = true;
      apiKey = { _secret = config.sops.secrets.seerr-api-key.path; };

      jellyfin = {
        externalHostname = "https://watch.zxxki.com";
      };
    };

    sonarr = {
      enable = true;
      openFirewall = false;
      mediaDirs = [ "/srv/media/library/shows" ];
      config.apiKey = { _secret = config.sops.secrets.sonarr-api-key.path; };
    };

    radarr = {
      enable = true;
      openFirewall = false;
      mediaDirs = [ "/srv/media/library/movies" ];
      config.apiKey = { _secret = config.sops.secrets.radarr-api-key.path; };
    };

    lidarr = {
      enable = true;
      openFirewall = false;
      mediaDirs = [ "/srv/media/library/music" ];
      config.apiKey = { _secret = config.sops.secrets.lidarr-api-key.path; };
    };

    prowlarr = {
      enable = true;
      openFirewall = false;
      config.apiKey = { _secret = config.sops.secrets.prowlarr-api-key.path; };
    };

    flaresolverr.enable = true;

    torrentClients.qbittorrent = {
      enable = true;
      downloadsDir = "/srv/media/torrents";
      webuiPort = 8112;
      password = { _secret = config.sops.secrets.qbittorrent-password.path; };
    };

    downloadarr = {
      qbittorrent = {
        password = { _secret = config.sops.secrets.qbittorrent-password.path; };
      };
    };
  };

  services.readarr = {
    enable = true;
    openFirewall = false;
    dataDir = "/data/.state/readarr";
  };

  services.bazarr = {
    enable = true;
    openFirewall = false;
  };

  users.users.readarr.extraGroups = [ "media" ];
  users.users.bazarr.extraGroups = [ "media" ];

  systemd.tmpfiles.rules = [
    "d /srv/media/library/manga 0775 root media -"
  ];
}
