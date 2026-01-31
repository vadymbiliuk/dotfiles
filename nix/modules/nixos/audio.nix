{ config, pkgs, lib, ... }:

{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber = {
      enable = true;
      extraConfig."99-rnnoise-default" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              { "node.name" = "rnnoise_source"; }
            ];
            actions = {
              update-props = {
                "priority.driver" = 8000;
                "priority.session" = 8000;
              };
            };
          }
        ];
      };
    };

    extraConfig = {
      pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 1024;
          "default.clock.max-quantum" = 2048;
        };
      };

      pipewire-pulse."92-low-latency" = {
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

      pipewire."99-input-denoising" = {
        "context.modules" = [
          {
            name = "libpipewire-module-filter-chain";
            args = {
              "node.description" = "Noise Canceling source";
              "media.name" = "Noise Canceling source";
              "filter.graph" = {
                nodes = [
                  {
                    type = "ladspa";
                    name = "rnnoise";
                    plugin = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                    label = "noise_suppressor_stereo";
                    control = {
                      "VAD Threshold (%)" = 50.0;
                      "VAD Grace Period (ms)" = 200;
                      "Retroactive VAD Grace (ms)" = 0;
                    };
                  }
                ];
              };
              "capture.props" = {
                "node.name" = "capture.rnnoise_source";
                "node.passive" = true;
                "audio.rate" = 48000;
                "audio.channels" = 2;
                "audio.position" = "FL,FR";
                "target.object" = "alsa_input.usb-SteelSeries_SteelSeries_Alias_Pro_1-00.analog-stereo";
              };
              "playback.props" = {
                "node.name" = "rnnoise_source";
                "media.class" = "Audio/Source";
                "audio.rate" = 48000;
                "audio.channels" = 2;
                "audio.position" = "FL,FR";
                "priority.session" = 2000;
                "priority.driver" = 2000;
              };
            };
          }
        ];
      };
    };
  };
}
