{ config, pkgs, lib, ... }:

{
  virtualisation.oci-containers.containers.lazylibrarian = {
    image = "lscr.io/linuxserver/lazylibrarian:latest";
    ports = [ "5299:5299" ];
    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "Europe/Kyiv";
    };
    volumes = [
      "lazylibrarian_config:/config"
      "/srv/media/books:/books"
      "/srv/media/downloads:/downloads"
    ];
    extraOptions = [ ];
  };

  services.nginx.virtualHosts."r-books.zxxki.com" = {
    useACMEHost = "zxxki.com";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:5299";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 20M;
      '';
    };
  };
}
