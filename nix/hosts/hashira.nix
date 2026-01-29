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
    ../modules/profiles/server-base.nix
    ../modules/nixos/homelab/vaultwarden.nix
    ../modules/nixos/homelab/syncthing.nix
    ../modules/nixos/homelab/adguard.nix
    ../modules/nixos/homelab/headscale.nix
    ../modules/nixos/homelab/nginx.nix
    ../modules/nixos/homelab/postgresql.nix
    ../modules/nixos/homelab/neo4j.nix
    ../modules/nixos/homelab/mongodb.nix
    ../modules/nixos/lanzaboote.nix
  ];

  networking.hostName = "hashira";

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets.vault-user-password = { };
  sops.secrets.cloudflare-api-token = { };

  users.users.zooki = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.sops.secrets.vault-user-password.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF1yHR4U8qcSV3xQjlmML+C1EmCr+7cif9++9YWZPUd2"
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [ 80 443 53 ];
    allowedUDPPorts = [ 53 ];
    trustedInterfaces = [ "tailscale0" ];
  };

  system.stateVersion = "24.11";
}
