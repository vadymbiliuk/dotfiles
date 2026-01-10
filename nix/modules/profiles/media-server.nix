{ config, pkgs, lib, ... }:

{
  imports = [ ./server-base.nix ];

  environment.systemPackages = with pkgs; [ ffmpeg ];

  networking.firewall.allowedTCPPorts = [
    8096 # Jellyfin
    32400 # Plex
  ];
}
