{ config, pkgs, lib, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
in {
  home.packages = lib.optionals isLinux (with pkgs; [
    jq
  ]);

  home.file.".config/scripts/auto-english.sh" = lib.mkIf isLinux {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      state_file="/tmp/auto-english-state"
      previous_app_id=""

      get_current_layout_idx() {
        niri msg keyboard-layouts 2>/dev/null | jq -r '.current_idx' 2>/dev/null || echo "0"
      }

      set_layout() {
        niri msg action switch-layout "$1" 2>/dev/null
      }

      get_focused_app_id() {
        niri msg focused-window 2>/dev/null | jq -r '.app_id // empty' 2>/dev/null
      }

      is_password_context() {
        local app_id="$1"
        case "$app_id" in
          firefox|chromium|chrome|brave|Firefox|Chrome|Chromium)
            return 0
            ;;
          kitty|kitty|Kitty)
            return 0
            ;;
          *)
            return 1
            ;;
        esac
      }

      handle_window_change() {
        local prev_app="$1"
        local curr_app="$2"
        local current_idx
        current_idx=$(get_current_layout_idx)

        if is_password_context "$curr_app"; then
          if [[ "$current_idx" != "0" ]]; then
            echo "$current_idx" > "$state_file"
            set_layout 0
          fi
        else
          if [[ -f "$state_file" ]]; then
            previous_idx=$(cat "$state_file" 2>/dev/null)
            if [[ -n "$previous_idx" && "$previous_idx" != "0" ]]; then
              set_layout "$previous_idx"
            fi
            rm -f "$state_file"
          fi
        fi
      }

      niri msg event-stream 2>/dev/null | while read -r event; do
        if echo "$event" | jq -e '.WindowFocusChanged' > /dev/null 2>&1; then
          current_app=$(get_focused_app_id)
          if [[ "$current_app" != "$previous_app_id" ]]; then
            handle_window_change "$previous_app_id" "$current_app"
            previous_app_id="$current_app"
          fi
        fi
      done
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