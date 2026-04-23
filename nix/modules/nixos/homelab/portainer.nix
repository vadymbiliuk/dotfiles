{ config, pkgs, lib, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  virtualisation.oci-containers = {
    backend = "docker";
    containers.portainer = {
      image = "portainer/portainer-ce:latest";
      ports = [ "9000:9000" ];
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock"
        "portainer_data:/data"
      ];
      extraOptions = [ ];
    };
  };

  services.nginx.virtualHosts."portainer.zxxki.com" = {
    useACMEHost = "zxxki.com";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:9000";
      proxyWebsockets = true;
      extraConfig = ''
        allow 127.0.0.1;
        allow 100.64.0.0/10;
        deny all;
      '';
    };
  };
}
