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
        HTTP_ADDR = "0.0.0.0";
        HTTP_PORT = 3300;
        DOMAIN = "hashira.tail.zxxki.com";
        ROOT_URL = "http://hashira.tail.zxxki.com:3300";
        SSH_DOMAIN = "hashira.tail.zxxki.com";
      };

      service = {
        DISABLE_REGISTRATION = true;
        REQUIRE_SIGNIN_VIEW = false;
      };

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
}
