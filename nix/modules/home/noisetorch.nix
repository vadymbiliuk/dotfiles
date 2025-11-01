{ config, pkgs, lib, ... }:

{
  systemd.user.services.noisetorch = {
    Unit = {
      Description = "NoiseTorch Noise Suppression";
      After = [ "graphical-session-pre.target" "pipewire.service" "pipewire-pulse.service" ];
      PartOf = [ "graphical-session.target" ];
      Wants = [ "pipewire.service" "pipewire-pulse.service" ];
    };
    Service = {
      Type = "forking";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
      ExecStart = "${pkgs.noisetorch}/bin/noisetorch -i -t 95";
      ExecStop = "${pkgs.noisetorch}/bin/noisetorch -u";
      Restart = "on-failure";
      RestartSec = 10;
      RemainAfterExit = true;
    };
    Install = {
      WantedBy = [ "graphical-session.target" "default.target" ];
    };
  };

  home.file.".config/scripts/noisetorch-toggle.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      
      if pgrep -x noisetorch > /dev/null; then
        noisetorch -u
        notify-send "NoiseTorch" "Noise suppression disabled"
      else
        noisetorch -i -t 95
        notify-send "NoiseTorch" "Noise suppression enabled"
      fi
    '';
  };
}