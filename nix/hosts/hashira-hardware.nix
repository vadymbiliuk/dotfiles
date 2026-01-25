{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/mapper/luks-986d6634-7f46-4236-88c6-8ba2fb0faec5";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-986d6634-7f46-4236-88c6-8ba2fb0faec5".device = "/dev/disk/by-uuid/986d6634-7f46-4236-88c6-8ba2fb0faec5";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/E2DE-5CB0";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/mapper/luks-706e3370-20ae-4140-b956-434d07c5d70e"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
