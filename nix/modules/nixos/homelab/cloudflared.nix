{ config, pkgs, lib, ... }:

{
  sops.secrets.cloudflare-tunnel-token = { };

  systemd.services.cloudflared-tunnel = {
    description = "Cloudflare Tunnel";
    after = [ "network-online.target" "systemd-resolved.service" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c 'exec ${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \"$(cat %d/token)\"'";
      Restart = "always";
      RestartSec = 5;
      LoadCredential = "token:${config.sops.secrets.cloudflare-tunnel-token.path}";
      DynamicUser = true;
    };
  };
}
