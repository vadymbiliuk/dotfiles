{ config, pkgs, lib, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    enableTCPIP = true;
    dataDir = "/var/lib/postgresql/17";
    authentication = lib.mkForce ''
      local all all trust
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
    };
    extensions = ps: with ps; [
      pgvector
      postgis
    ];
  };
}
