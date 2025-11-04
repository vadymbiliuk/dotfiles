{ config, pkgs, lib, ... }:

let isLinux = pkgs.stdenv.isLinux;
in {
  home.packages = lib.optionals isLinux [ pkgs.walker ];

  xdg.configFile."walker/themes/blur.css" = lib.mkIf isLinux {
    text = ''
      @define-color foreground rgba(0, 0, 0, 0.9);
      @define-color background alpha(#080808, 0.5);
      @define-color color1 #DDD;

      #window, #box, #aiScroll, #aiList, #search, #password, #input, #prompt, #clear, #typeahead, #list, child, scrollbar, slider, #item, #text, #label, #bar, #sub, #activationlabel {
        all: unset;
        font-family: "BerkeleyMonoMinazuki Nerd Font Mono";
        font-size: 16px;
        font-weight: bold;
      }

      #window { color: @foreground; }

      #box {
        border-radius: 10px;
        background: @background;
        padding: 32px;
        border: 3px solid rgba(42, 42, 42, 0.65);
        box-shadow: 0 19px 38px rgba(0, 0, 0, 0.3), 0 15px 12px rgba(0, 0, 0, 0.22);
      }

      #search {
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1), 0 1px 2px rgba(0, 0, 0, 0.22);
        background: alpha(#080808, 0.3);
        padding: 8px;
      }

      #prompt { margin-left: 4px; margin-right: 12px; color: @foreground; opacity: 0.2; }
      #clear { color: @foreground; opacity: 0.8; }
      #password, #input, #typeahead { border-radius: 2px; }
      #input { background: none; color: @color1; }
      #typeahead { color: @foreground; opacity: 0.8; }
      #input placeholder { opacity: 0.5; }
      child { padding: 8px; border-radius: 2px; color: @color1; }
      child:selected, child:hover { background: alpha(@color1, 0.4); color: @foreground; }
      #icon { margin-right: 8px; }
      #label { font-weight: 500; }
      #sub { opacity: 0.5; font-size: 0.8em; }
    '';
  };

  xdg.configFile."walker/config.toml" = lib.mkIf isLinux {
    text = ''
      theme = "blur"
      close_when_open = false
      monitor = ""
      hotreload_theme = false
      as_window = false
      timeout = 200
      disable_click_to_close = false
      force_keyboard_focus = false
      show_initial_entries = true
      
      [[modules]]
      name = "applications"
      prefix = ""
      
      [[modules]]
      name = "runner"
      prefix = "!"
      
      [[modules]]
      name = "dmenu"
      prefix = "?"
      
      [[modules]]
      name = "clipboard"
      prefix = "#"

      [keys]
      accept_typeahead = ["tab"]
      trigger_labels = "lalt"
      next = ["down"]
      prev = ["up"]
      close = ["esc"]
    '';
  };

  home.file.".config/scripts/wallpaper-picker.sh" = lib.mkIf isLinux {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      wallpaper_dir="$HOME/.config/wallpapers"

      selected=$(ls "$wallpaper_dir"/*.{jpg,png,jpeg} 2>/dev/null | xargs -n 1 basename | walker --dmenu)

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
