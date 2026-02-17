{ config, pkgs, lib, ... }:

let isLinux = pkgs.stdenv.isLinux;
in {
  programs.rofi = lib.mkIf isLinux {
    enable = true;
    package = pkgs.rofi;
    theme = builtins.toFile "custom-theme.rasi" ''
      * {
          y-offset: -400;
          width: 1000;
          items: 10;

          lack:   #708090;
          luster: #deeeed;
          orange: #ffaa88;
          green:  #789978;
          blue:   #7788AA;
          red:    #D70000;
          black:  #000000;
          gray0:  #000000;
          gray1:  #080808;
          gray2:  #191919;
          gray3:  #2a2a2a;
          gray4:  #444444;
          gray5:  #555555;
          gray6:  #7a7a7a;
          gray7:  #aaaaaa;
          gray8:  #cccccc;
          gray9:  #DDDDDD;
      }

      * {
          font: "BerkeleyMonoMinazuki Nerd Font Mono 16";
          background-color: transparent;
          text-color: @gray9;
          margin: 0px;
          padding: 0px;
          spacing: 0px;
      }

      window {
          background-color: rgba(10, 10, 10, 0.6);
          y-offset: @y-offset;
          width: @width;
          border-radius: 10px;
          border: 3px solid;
          border-color: rgba(42, 42, 42, 0.4);
      }

      mainbox {
          padding: 10px;
      }

      inputbar {
          background-color: transparent;
          padding: 8px 16px;
          spacing: 16px;
          children: [ prompt, entry ];
      }

      prompt {
          text-color: @gray6;
      }

      entry {
          placeholder: "...";
          placeholder-color: @gray5;
      }

      message {
          margin: 16px 0 0;
          background-color: transparent;
      }

      textbox {
          padding: 8px 24px;
      }

      listview {
          background-color: transparent;
          scrollbar: true;
          scrollbar-width: 5;
          margin: 10px 0 0;
          columns: 1;
          lines: @items;
          dynamic: true;
          fixed-height: false;
      }

      scrollbar {
          background-color: rgba(42, 42, 42, 0.3);
          handle-width: 10px;
          handle-color: rgba(85, 85, 85, 0.5);
          margin: 0px 0px 0px 10px;
      }

      element {
          padding: 8px 16px;
          spacing: 8px;
      }

      element-icon {
          size: 1em;
          vertical-align: 0.5;
      }

      element-text {
          text-color: @gray6;
      }
      element selected normal, element selected active {
          background-color: @gray1;
          text-color: @gray9;
      }

      element-text selected {
          text-color: @gray9;
      }
    '';
    extraConfig = {
      modi = "run,drun,window";
      show-icons = true;
      display-drun = "Applications";
      display-run = "Run";
      display-window = "Windows";
      drun-display-format = "{name}";
      terminal = "ghostty";
      matching = "fuzzy";
      sort = true;
      disable-history = false;
      show-match = true;
      scroll-method = 1;
      window-format = "{w} {i} {c} {t}";
      click-to-exit = true;
      me-select-entry = "";
      me-accept-entry = "MousePrimary";
      normal-window = false;
      steal-focus = true;
    };
  };

  home.file.".config/scripts/wallpaper-picker.sh" = lib.mkIf isLinux {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      wallpaper_dir="$HOME/.config/wallpapers"

      selected=$(ls "$wallpaper_dir"/*.{jpg,png,jpeg} 2>/dev/null | xargs -n 1 basename | rofi -dmenu -p "Wallpaper")

      if [ -n "$selected" ]; then
        ln -sf "$wallpaper_dir/$selected" "$wallpaper_dir/current"

        if pgrep -x swww-daemon > /dev/null; then
          swww img "$wallpaper_dir/$selected" --transition-type fade
        elif pgrep -x hyprpaper > /dev/null; then
          pkill hyprpaper
          hyprpaper &
        fi
      fi
    '';
  };
}

