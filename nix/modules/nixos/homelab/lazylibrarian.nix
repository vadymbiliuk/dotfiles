{ config, pkgs, lib, ... }:

{
  virtualisation.oci-containers.containers.lazylibrarian = {
    image = "lscr.io/linuxserver/lazylibrarian:latest";
    extraOptions = [ "--network=host" ];
    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "Europe/Kyiv";
    };
    volumes = [
      "lazylibrarian_config:/config"
      "/srv/media/library/books:/books"
      "/srv/media/library/manga:/manga"
      "/srv/media/torrents:/downloads"
    ];
  };

  services.nginx.virtualHosts."r-books.zxxki.com" = {
    useACMEHost = "zxxki.com";
    forceSSL = true;
    extraConfig = ''
      if ($bad_bot) { return 444; }
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:5299";
      proxyWebsockets = true;
      extraConfig = ''
        limit_req zone=general burst=20 nodelay;
        client_max_body_size 20M;
      '';
    };
  };
}
