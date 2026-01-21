{ config, pkgs, lib, ... }:

{
  services.easyeffects = {
    enable = true;
    preset = "General";
  };

  xdg.dataFile."easyeffects/input/General.json".text = builtins.toJSON {
    input = {
      blocklist = [];
      "deepfilternet#0" = {
        attenuation-limit = 100.0;
        bypass = false;
        input-gain = 0.0;
        max-df-processing-threshold = 20.0;
        max-erb-processing-threshold = 30.0;
        min-processing-buffer = 0;
        min-processing-threshold = -10.0;
        output-gain = 0.0;
        post-filter-beta = 0.019999999552965164;
      };
      "exciter#0" = {
        amount = 0.0;
        blend = 0.0;
        bypass = false;
        ceil = 16000.0;
        ceil-active = false;
        harmonics = 8.5;
        input-gain = 0.0;
        output-gain = 0.0;
        scope = 7500.0;
      };
      plugins_order = [
        "deepfilternet#0"
        "rnnoise#0"
        "speex#0"
        "exciter#0"
        "stereo_tools#0"
      ];
      "rnnoise#0" = {
        bypass = false;
        enable-vad = true;
        input-gain = 0.0;
        model-name = "\"\"";
        output-gain = 0.0;
        release = 20.0;
        use-standard-model = true;
        vad-thres = 50.0;
        wet = 0.0;
      };
      "speex#0" = {
        bypass = false;
        enable-agc = true;
        enable-denoise = true;
        enable-dereverb = true;
        input-gain = 0.0;
        noise-suppression = -70;
        output-gain = 0.0;
        vad = {
          enable = true;
          probability-continue = 90;
          probability-start = 95;
        };
      };
      "stereo_tools#0" = {
        balance-in = 0.0;
        balance-out = 0.0;
        bypass = false;
        delay = 0.0;
        dry = -100.0;
        input-gain = 0.0;
        middle-level = 0.0;
        middle-panorama = 0.0;
        mode = "LR > LR (Stereo Default)";
        mutel = false;
        muter = false;
        output-gain = 0.0;
        phasel = false;
        phaser = false;
        sc-level = 1.0;
        side-balance = 0.0;
        side-level = 0.0;
        softclip = false;
        stereo-base = 0.0;
        stereo-phase = 0.0;
        wet = 0.0;
      };
    };
  };
}
