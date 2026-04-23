{ config, pkgs, lib, ... }:

let
  setPasswordScript = pkgs.writeShellScript "neo4j-set-password" ''
    PASSWORD=$(cat ${config.sops.secrets.db-admin-password.path})
    ${pkgs.curl}/bin/curl -s -X POST \
      -H "Content-Type: application/json" \
      -d "{\"password\":\"$PASSWORD\"}" \
      http://localhost:7474/user/neo4j/password \
      -u neo4j:neo4j 2>/dev/null || true
  '';
in
{
  services.neo4j = {
    enable = true;
    directories = {
      home = "/var/lib/neo4j";
      data = "/var/lib/neo4j/data";
    };
    http = {
      enable = true;
      listenAddress = "0.0.0.0:7474";
      advertisedAddress = "localhost:7474";
    };
    https = {
      enable = false;
    };
    bolt = {
      enable = true;
      listenAddress = "0.0.0.0:7687";
      advertisedAddress = "localhost:7687";
    };
    extraServerConfig = ''
      dbms.security.auth_enabled=true
    '';
  };

  systemd.services.neo4j-set-password = {
    description = "Set Neo4j admin password from sops";
    after = [ "neo4j.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
      ExecStart = setPasswordScript;
    };
  };
}
