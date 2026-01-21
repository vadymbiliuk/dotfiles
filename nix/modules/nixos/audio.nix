{ config, pkgs, lib, ... }:

{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    wireplumber.extraConfig."10-default-devices" = {
      "wireplumber.settings" = {
        "default.configured.audio.sink" = "easyeffects_sink";
        "default.configured.audio.source" = "easyeffects_source";
      };
    };

    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 1024;
        "default.clock.max-quantum" = 2048;
      };
    };

    extraConfig.pipewire-pulse."92-low-latency" = {
      "pulse.properties" = {
        "pulse.min.req" = "1024/48000";
        "pulse.default.req" = "1024/48000";
        "pulse.max.req" = "2048/48000";
        "pulse.min.quantum" = "1024/48000";
        "pulse.max.quantum" = "2048/48000";
      };
      "stream.properties" = {
        "node.latency" = "1024/48000";
      };
    };

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

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}

