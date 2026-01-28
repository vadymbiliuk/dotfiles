{ config, pkgs, lib, ... }:

{
  sops.secrets.cloudflared-tunnel-token = { };

  systemd.services.cloudflared-tunnel = {
    description = "Cloudflare Tunnel";
    after = [ "network-online.target" "systemd-resolved.service" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token %d/token";
      Restart = "always";
      RestartSec = 5;
      LoadCredential = "token:${config.sops.secrets.cloudflared-tunnel-token.path}";
      DynamicUser = true;
    };
  };
}
