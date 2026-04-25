{ config, pkgs, lib, ... }:

{
  imports = [ ./server-base.nix ];

  environment.systemPackages = with pkgs; [ ffmpeg ];
}
