{ config, pkgs, lib, ... }:

{
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    
    extraConfig.pipewire.rtconfig = {
      "context.modules" = [
        {
          name = "libpipewire-module-rt";
          args = {
            "rt.prio" = 88;
            "nice.level" = -11;
            "rt.time.soft" = -1;
            "rt.time.hard" = -1;
            "uclamp.min" = 0;
            "uclamp.max" = 1024;
          };
          flags = [
            "ifexists"
            "nofail"
          ];
        }
      ];
    };
  };

  programs.noisetorch.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}

