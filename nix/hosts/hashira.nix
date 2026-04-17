{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ./hashira-hardware.nix
    ../modules/profiles/media-server.nix
    ../modules/nixos/homelab/vaultwarden.nix
    ../modules/nixos/homelab/syncthing.nix
    ../modules/nixos/homelab/adguard.nix
    ../modules/nixos/homelab/headscale.nix
    ../modules/nixos/homelab/nginx.nix
    ../modules/nixos/homelab/postgresql.nix
    ../modules/nixos/homelab/neo4j.nix
    ../modules/nixos/homelab/mongodb.nix
    ../modules/nixos/homelab/jellyfin.nix
    ../modules/nixos/homelab/jellyseerr.nix
    ../modules/nixos/homelab/qbittorrent.nix
    ../modules/nixos/homelab/prowlarr.nix
    ../modules/nixos/homelab/sonarr.nix
    ../modules/nixos/homelab/radarr.nix
    ../modules/nixos/homelab/lidarr.nix
    ../modules/nixos/homelab/readarr.nix
    ../modules/nixos/homelab/bazarr.nix
    ../modules/nixos/homelab/flaresolverr.nix
    ../modules/nixos/homelab/media-backup.nix
    ../modules/nixos/homelab/crowdsec.nix
    ../modules/nixos/homelab/prometheus.nix
    ../modules/nixos/homelab/grafana.nix
    ../modules/nixos/homelab/gitea.nix
    ../modules/nixos/homelab/fail2ban-notify
    ../modules/nixos/homelab/hardening.nix
    ../modules/nixos/homelab/remote-unlock.nix
    ../modules/nixos/lanzaboote.nix
  ];

  networking.hostName = "hashira";

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets.vault-user-password = { };
  sops.secrets.cloudflare-api-token = { };
  sops.secrets.grafana-secret-key = {
    owner = "grafana";
  };
  sops.secrets.grafana-discord-webhook = {
    owner = "grafana";
  };
  sops.secrets.grafana-telegram-token = {
    owner = "grafana";
  };

  users.users.zooki = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.sops.secrets.vault-user-password.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF1yHR4U8qcSV3xQjlmML+C1EmCr+7cif9++9YWZPUd2"
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [ 22 80 443 53 2222 ];
    allowedUDPPorts = [ 53 ];
    trustedInterfaces = [ "tailscale0" ];
  };

  system.stateVersion = "24.11";
}
