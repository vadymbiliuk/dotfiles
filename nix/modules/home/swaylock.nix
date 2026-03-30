{ pkgs, ... }:

{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      image = "~/.config/wallpapers/wallpaper.jpg";
      clock = true;
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;
      effect-blur = "8x3";
      effect-vignette = "0.5:0.5";
      ring-color = "808080cc";
      key-hl-color = "aaaaaaff";
      line-color = "00000000";
      inside-color = "40404080";
      separator-color = "00000000";
      text-color = "c8c8c8ff";
      font = "BerkeleyMonoMinazuki Nerd Font";
      timestr = "%H:%M";
      datestr = "%A, %B %d";
      fade-in = 0.2;
      ignore-empty-password = true;
      show-keyboard-layout = true;
    };
  };
}
