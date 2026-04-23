{ config, pkgs, lib, ... }:

let
  initScript = pkgs.writeShellScript "mongo-init-admin" ''
    PASSWORD=$(cat ${config.sops.secrets.db-admin-password.path})

    ${pkgs.mongosh}/bin/mongosh -u admin -p "$PASSWORD" --authenticationDatabase admin --eval "db.runCommand({ping:1})" 2>/dev/null && exit 0

    ${pkgs.mongosh}/bin/mongosh --eval "
      db = db.getSiblingDB('admin');
      db.createUser({
        user: 'admin',
        pwd: '$PASSWORD',
        roles: [{ role: 'root', db: 'admin' }]
      });
    " 2>/dev/null || true
  '';
in
{
  sops.secrets.db-admin-password = {
    owner = "postgres";
  };

  services.mongodb = {
    enable = true;
    package = pkgs.mongodb-ce;
    dbpath = "/var/lib/mongodb";
    bind_ip = "0.0.0.0";
    extraConfig = ''
      security.authorization: enabled
    '';
  };

  systemd.services.mongodb-init-admin = {
    description = "Initialize MongoDB admin user from sops";
    after = [ "mongodb.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = initScript;
    };
  };
}
