{ config, pkgs, lib, ... }:

{
  imports = [ ./server-base.nix ];

  environment.systemPackages = with pkgs; [ ffmpeg ];

  users.groups.media = { };

  systemd.tmpfiles.rules = [
    "d /srv/media 0775 root media -"
    "d /srv/media/downloads 0775 root media -"
    "d /srv/media/movies 0775 root media -"
    "d /srv/media/tv 0775 root media -"
    "d /srv/media/music 0775 root media -"
    "d /srv/media/books 0775 root media -"
  ];
}
