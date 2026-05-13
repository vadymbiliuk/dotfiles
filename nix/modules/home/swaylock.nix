{ pkgs, ... }:

let
  theme = import ../themes/monochrome.nix;
  c = theme.colors.lockscreen;
  l = theme.layout.lockscreen;
in
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      image = "~/.config/wallpapers/wallpaper.jpg";
      clock = true;
      indicator = true;
      indicator-radius = l.indicatorRadius;
      indicator-thickness = l.indicatorThickness;
      effect-blur = l.effectBlur;
      effect-vignette = l.effectVignette;
      ring-color = c.ring;
      key-hl-color = c.keyHighlight;
      line-color = c.line;
      inside-color = c.inside;
      separator-color = c.separator;
      text-color = c.text;
      font = "BerkeleyMonoMinazuki Nerd Font";
      timestr = "%H:%M";
      datestr = "%A, %B %d";
      fade-in = l.fadeIn;
      ignore-empty-password = true;
      show-keyboard-layout = true;
    };
  };
}
