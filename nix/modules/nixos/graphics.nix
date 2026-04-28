{ lib, config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ADW_DEBUG_COLOR_SCHEME = "prefer-dark";
    NVD_BACKEND = "direct";
    LIBVA_DRIVER_NAME = "nvidia";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };
}
