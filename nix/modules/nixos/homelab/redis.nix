{ config, pkgs, lib, ... }:

{
  services.redis.servers.main = {
    enable = true;
    port = 6379;
    bind = "127.0.0.1";
    settings = {
      maxmemory = "256mb";
      maxmemory-policy = "allkeys-lru";
    };
  };

  services.prometheus.exporters.redis = {
    enable = true;
    port = 9121;
  };
}
