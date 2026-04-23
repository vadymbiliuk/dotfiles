{ config, pkgs, lib, ... }:

{
  services.apache-kafka = {
    enable = true;
    clusterId = "hashira-kafka-01";
    formatLogDirs = true;

    settings = {
      "listeners" = [ "PLAINTEXT://127.0.0.1:9092" "CONTROLLER://127.0.0.1:9093" ];
      "advertised.listeners" = [ "PLAINTEXT://127.0.0.1:9092" ];
      "controller.listener.names" = [ "CONTROLLER" ];
      "listener.security.protocol.map" = [ "CONTROLLER:PLAINTEXT" "PLAINTEXT:PLAINTEXT" ];
      "controller.quorum.voters" = [ "1@127.0.0.1:9093" ];
      "node.id" = 1;
      "process.roles" = [ "broker" "controller" ];
      "log.dirs" = [ "/var/lib/apache-kafka" ];
      "num.partitions" = 3;
      "default.replication.factor" = 1;
      "log.retention.hours" = 168;
      "log.segment.bytes" = 1073741824;
    };
  };
}
