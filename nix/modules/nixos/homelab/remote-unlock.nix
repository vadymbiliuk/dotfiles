{ config, pkgs, lib, ... }:

{
  boot.initrd.availableKernelModules = [
    "virtio_net"
    "e1000"
    "e1000e"
    "r8169"
    "igb"
    "ixgbe"
  ];

  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 2222;
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF1yHR4U8qcSV3xQjlmML+C1EmCr+7cif9++9YWZPUd2"
      ];
      hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
    };
  };

  boot.initrd.luks.devices."luks-986d6634-7f46-4236-88c6-8ba2fb0faec5".allowDiscards = true;

  virtualisation.vmVariant = {
    boot.initrd.network.ssh.enable = lib.mkForce false;
    boot.initrd.network.enable = lib.mkForce false;
  };
}
