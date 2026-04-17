{ config, pkgs, lib, ... }:

{
  services.gitea = {
    enable = true;

    database = {
      type = "postgres";
      name = "gitea";
      user = "gitea";
      socket = "/run/postgresql";
    };

    settings = {
      server = {
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3300;
        DOMAIN = "git.zxxki.com";
        ROOT_URL = "https://git.zxxki.com";
        SSH_DOMAIN = "git.zxxki.com";
      };

      service = {
        DISABLE_REGISTRATION = true;
        REQUIRE_SIGNIN_VIEW = true;
      };

      session.COOKIE_SECURE = true;

      mailer.ENABLED = false;

      log.LEVEL = "Warn";
    };
  };

  services.postgresql = {
    ensureDatabases = [ "gitea" ];
    ensureUsers = [{
      name = "gitea";
      ensureDBOwnership = true;
    }];
  };

  services.nginx.virtualHosts."git.zxxki.com" = {
    useACMEHost = "zxxki.com";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3300";
      proxyWebsockets = true;
      extraConfig = ''
        allow 127.0.0.1;
        allow 100.64.0.0/10;
        deny all;
        client_max_body_size 512M;
      '';
    };
  };
}
