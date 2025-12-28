{ config, pkgs, lib, inputs, ... }:

let
  drataAgent = inputs.drata-agent.packages.${pkgs.system}.drata-agent;
in
{
  environment.systemPackages = [ drataAgent ];

  systemd.user.services.drata-agent = {
    description = "Drata Compliance Agent";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session-pre.target" ];
    
    serviceConfig = {
      Type = "simple";
      ExecStart = "${drataAgent}/bin/drata-agent";
      Restart = "on-failure";
      RestartSec = 5;
    };

    environment = {
      DISPLAY = ":0";
      ELECTRON_IS_DEV = "0";
    };
  };

  users.users.minazuki.packages = [ drataAgent ];
}