{ config, pkgs, lib, ... }:

{
  services.rabbitmq = {
    enable = true;
    listenAddress = "127.0.0.1";
    port = 5672;
    managementPlugin.enable = true;
    managementPlugin.port = 15672;
  };

  services.nginx.virtualHosts."rabbitmq.zxxki.com" = {
    useACMEHost = "zxxki.com";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:15672";
      proxyWebsockets = true;
      extraConfig = ''
        allow 127.0.0.1;
        allow 100.64.0.0/10;
        deny all;
      '';
    };
  };
}
