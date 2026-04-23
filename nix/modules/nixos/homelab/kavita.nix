{ config, pkgs, lib, ... }:

{
  services.kavita = {
    enable = true;
    settings.Port = 5000;
    tokenKeyFile = config.sops.secrets.kavita-token-key.path;
  };

  sops.secrets.kavita-token-key = {
    owner = "kavita";
  };

  users.users.kavita.extraGroups = [ "media" ];

  services.nginx.virtualHosts."read.zxxki.com" = {
    useACMEHost = "zxxki.com";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:5000";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 100M;
      '';
    };
  };
}
