{ config, pkgs, lib, ... }:

{
  services.qbittorrent = {
    enable = true;
    webuiPort = 8112;
    torrentingPort = 50000;
    serverConfig = {
      LegalNotice.Accepted = true;
      Preferences = {
        "Downloads\\SavePath" = "/srv/media/downloads";
        "WebUI\\Address" = "0.0.0.0";
      };
    };
  };

  users.users.qbittorrent.extraGroups = [ "media" ];
}
