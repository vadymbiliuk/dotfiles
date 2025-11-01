{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    tpm2-tools
    tpm2-tss
    os-prober
  ];
  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [
      "nvidia-drm.modeset=1"
      "video=DP-1:2560x1440@360"
    ];
    supportedFilesystems = [ "ntfs" ];
    tmp.cleanOnBoot = true;
    
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        configurationLimit = 10;
        extraEntries = ''
          menuentry "Windows 11" {
            search --fs-uuid --no-floppy --set=root 609D-8B8B
            chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
          }
        '';
      };
    };

    kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.dirty_ratio" = 15;
      "vm.dirty_background_ratio" = 5;
    };

    initrd = {
      systemd.enable = true;
      luks.devices."luks-1ad4df4c-ec09-4723-bc9f-538a9f2aace3" = {
        device = "/dev/disk/by-uuid/1ad4df4c-ec09-4723-bc9f-538a9f2aace3";
        crypttabExtraOpts = [ "tpm2-device=auto" "tpm2-pcrs=7" ];
      };
    };
  };

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };
}