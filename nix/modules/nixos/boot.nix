{
  config,
  pkgs,
  lib,
  ...
}:

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
      "nvidia_drm.fbdev=1"
      "video=DP-1:2560x1440@500"
      "video=DP-2:2560x1440@360,rotate=90"
      "loglevel=3"
    ];
    supportedFilesystems = [ "ntfs" ];
    tmp.cleanOnBoot = true;

    extraModprobeConfig = ''
      blacklist nouveau
      options nouveau modeset=0
    '';
    blacklistedKernelModules = [ "nouveau" ];

    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        configurationLimit = 10;
      };
    };

    kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.dirty_ratio" = 15;
      "vm.dirty_background_ratio" = 5;
    };

    initrd = {
      systemd.enable = true;
      luks.devices."luks-1524803b-1aee-47d5-b377-8ac4ad7c67b5" = {
        device = "/dev/disk/by-uuid/1524803b-1aee-47d5-b377-8ac4ad7c67b5";
        crypttabExtraOpts = [ "tpm2-device=auto" ];
      };
      systemd.tpm2.enable = true;
    };
  };

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };
}
