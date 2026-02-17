{ config, lib, pkgs, ... }:

{
  programs.ghostty = {
    themes = {
      monochrome = {
        palette = [
          "0=#1c1e23"
          "1=#555555"
          "2=#5e5e5e"
          "3=#666666"
          "4=#6e6e6e"
          "5=#777777"
          "6=#7f7f7f"
          "7=#b0b0b0"
          "8=#2b2e34"
          "9=#888888"
          "10=#8f8f8f"
          "11=#999999"
          "12=#a2a2a2"
          "13=#ababab"
          "14=#b5b5b5"
          "15=#d6d6d6"
        ];
        background = "0a0a0a";
        foreground = "deeeed";
        cursor-color = "d6d6d6";
        cursor-text = "181a1f";
        selection-background = "3a3f4b";
        selection-foreground = "e0e0e0";
      };

      lucklaster = {
        palette = [
          "0=#080808"
          "1=#d70000"
          "2=#789978"
          "3=#ffaa88"
          "4=#7788aa"
          "5=#d7007d"
          "6=#708090"
          "7=#deeeed"
          "8=#444444"
          "9=#d70000"
          "10=#789978"
          "11=#ffaa88"
          "12=#7788aa"
          "13=#d7007d"
          "14=#708090"
          "15=#deeeed"
        ];
        background = "0a0a0a";
        foreground = "deeeed";
        cursor-color = "deeeed";
        cursor-text = "0a0a0a";
        selection-background = "7a7a7a";
        selection-foreground = "0a0a0a";
      };
    };
  };
}
