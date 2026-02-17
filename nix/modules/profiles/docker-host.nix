{ config, pkgs, lib, ... }:

{
  imports = [ ./server-base.nix ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  environment.systemPackages = with pkgs; [ docker-compose ];

  networking.firewall.trustedInterfaces = [ "docker0" ];
}
