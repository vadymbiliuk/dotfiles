{ config, pkgs, lib, ... }:

let
  initScript = pkgs.writeText "pg-init.sql" ''
    REVOKE ALL ON DATABASE postgres FROM PUBLIC;
    REVOKE CREATE ON SCHEMA public FROM PUBLIC;

    DO $$
    BEGIN
      IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'admin') THEN
        CREATE ROLE admin WITH LOGIN CREATEDB CREATEROLE;
      END IF;
    END
    $$;

    GRANT ALL PRIVILEGES ON DATABASE postgres TO admin;
  '';

  setPasswordScript = pkgs.writeShellScript "pg-set-admin-password" ''
    PASSWORD=$(cat ${config.sops.secrets.db-admin-password.path})
    ${config.services.postgresql.package}/bin/psql -U postgres -c "
      DO \$\$
      BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'admin') THEN
          CREATE ROLE admin WITH LOGIN CREATEDB CREATEROLE;
        END IF;
      END
      \$\$;
      ALTER ROLE admin WITH PASSWORD '$PASSWORD';
      GRANT ALL PRIVILEGES ON DATABASE postgres TO admin;
    "
  '';
in
{
  sops.secrets.db-admin-password = {
    owner = "postgres";
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    enableTCPIP = true;
    dataDir = "/var/lib/postgresql/17";
    authentication = lib.mkForce ''
      local all postgres peer
      local gitea gitea peer
      local all all scram-sha-256
      host all all 127.0.0.1/32 scram-sha-256
      host all all ::1/128 scram-sha-256
      host all all 100.64.0.0/10 scram-sha-256
    '';
    settings = {
      listen_addresses = "*";
      max_connections = 100;
      shared_buffers = "256MB";
      effective_cache_size = "1GB";
      maintenance_work_mem = "128MB";
      checkpoint_completion_target = 0.9;
      wal_buffers = "16MB";
      default_statistics_target = 100;
      random_page_cost = 1.1;
      effective_io_concurrency = 200;
      min_wal_size = "1GB";
      max_wal_size = "4GB";
      log_connections = true;
      log_disconnections = true;
    };
    extensions = ps: with ps; [
      pgvector
      postgis
    ];
    initialScript = initScript;
  };

  systemd.services.postgresql-set-password = {
    description = "Set PostgreSQL admin password from sops";
    after = [ "postgresql.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "postgres";
      ExecStart = setPasswordScript;
    };
  };
}
