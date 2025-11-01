{ config, pkgs, lib, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
in {
  home.packages = lib.optionals isLinux (with pkgs; [
    xdotool
    wmctrl
    socat
  ]);

  home.file.".config/scripts/auto-english.sh" = lib.mkIf isLinux {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      
      state_file="/tmp/auto-english-state"
      previous_window=""
      
      get_current_layout() {
        hyprctl devices -j | jq -r '.keyboards[] | select(.name=="wooting-wooting-80he") | .active_keymap' 2>/dev/null || echo "0"
      }
      
      set_layout() {
        local layout="$1"
        hyprctl switchxkblayout wooting-wooting-80he "$layout" 2>/dev/null
      }
      
      get_window_class() {
        hyprctl activewindow -j | jq -r '.class // empty' 2>/dev/null
      }
      
      is_password_context() {
        local window_class="$1"
        case "$window_class" in
          firefox|chromium|chrome|brave|Firefox|Chrome|Chromium)
            return 0
            ;;
          ghostty|com.mitchellh.ghostty|Ghostty)
            return 0
            ;;
          *)
            return 1
            ;;
        esac
      }
      
      log_debug() {
        echo "$(date): $1" >> /tmp/auto-english.log
      }
      
      handle_window_change() {
        local prev_window="$1"
        local curr_window="$2"
        local current_layout=$(get_current_layout)
        
        log_debug "Focus changed: $prev_window -> $curr_window (Layout: $current_layout)"
        
        if is_password_context "$curr_window"; then
          # Switching TO a password context app
          if [[ "$current_layout" != "English (US)" && "$current_layout" != "0" ]]; then
            echo "$current_layout" > "$state_file"
            set_layout 0
            log_debug "Switched to English from $current_layout"
          fi
        else
          # Switching AWAY from password context app
          if [[ -f "$state_file" ]]; then
            previous_layout=$(cat "$state_file" 2>/dev/null)
            if [[ -n "$previous_layout" && "$previous_layout" != "English (US)" && "$previous_layout" != "0" ]]; then
              case "$previous_layout" in
                *Russian*|*ru*|"1") set_layout 1 ;;
                *Ukrainian*|*ua*|"2") set_layout 2 ;;
              esac
              rm -f "$state_file"
              log_debug "Restored to $previous_layout"
            fi
          fi
        fi
      }
      
      # Monitor window focus events using socat to listen to Hyprland socket
      if [[ -n "$XDG_RUNTIME_DIR" ]]; then
        socket_path="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
      else
        socket_path="/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
      fi
      
      if [[ ! -S "$socket_path" ]]; then
        log_debug "Hyprland socket not found at $socket_path, falling back to polling"
        while true; do
          current_window=$(get_window_class)
          if [[ "$current_window" != "$previous_window" ]]; then
            handle_window_change "$previous_window" "$current_window"
            previous_window="$current_window"
          fi
          sleep 1
        done
      else
        log_debug "Listening to Hyprland events on $socket_path"
        socat -U UNIX-CONNECT:"$socket_path" - | while read -r event; do
          if [[ "$event" == activewindow* ]]; then
            current_window=$(get_window_class)
            if [[ "$current_window" != "$previous_window" ]]; then
              handle_window_change "$previous_window" "$current_window"
              previous_window="$current_window"
            fi
          fi
        done
      fi
    '';
  };

  systemd.user.services.auto-english = lib.mkIf isLinux {
    Unit = {
      Description = "Auto English Layout for Password Fields";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${config.home.homeDirectory}/.config/scripts/auto-english.sh";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}