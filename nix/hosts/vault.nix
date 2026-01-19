{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ../modules/profiles/vault-server.nix
  ];

  networking.hostName = "vault";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  sops.secrets.vault-user-password = { };

  users.users.zooki = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.sops.secrets.vault-user-password.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF1yHR4U8qcSV3xQjlmML+C1EmCr+7cif9++9YWZPUd2"
    ];
  };

  services.vaultwarden.config = {
    DOMAIN = lib.mkForce "https://vault.local";
  };

  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };

  system.stateVersion = "24.11";
}
