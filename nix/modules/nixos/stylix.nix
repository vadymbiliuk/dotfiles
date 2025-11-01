{ config, pkgs, lib, ... }:

{
  stylix = {
    enable = true;
    image = ../../wallpapers/wallpaper.jpg;
    polarity = "dark";
    
    base16Scheme = {
      base00 = "080808";
      base01 = "191919";
      base02 = "2a2a2a";
      base03 = "444444";
      base04 = "555555";
      base05 = "ddd";
      base06 = "cccccc";
      base07 = "dddddd";
      base08 = "D70000";
      base09 = "ffaa88";
      base0A = "abab77";
      base0B = "789978";
      base0C = "708090";
      base0D = "7788AA";
      base0E = "708090";
      base0F = "ffaa88";
    };
    
    targets = {
      waybar.enable = true;
    };
  };
}