{
  config,
  pkgs,
  lib,
  ...
}:

{

  services.mako.enable = false;

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [ pkgs.hyprlandPlugins.hyprexpo ];
    settings = {
      monitor = [
        "DP-2,2560x1440@359.98,0x0,1,transform,1"
        "DP-1,2560x1440@500,1440x730,1"
      ];

      workspace = [
        "1, monitor:DP-1, default:true"
        "2, monitor:DP-1"
        "3, monitor:DP-1"
        "4, monitor:DP-1"
        "5, monitor:DP-1"
        "6, monitor:DP-2"
        "7, monitor:DP-2"
        "8, monitor:DP-2"
        "9, monitor:DP-2"
        "10, monitor:DP-2"
      ];

      "$terminal" = "ghostty";
      "$fileManager" = "dolphin";
      "$menu" = "rofi -show drun";

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "XCURSOR_THEME,Bibata-Modern-Classic"
      ];

      general = {
        gaps_in = 8;
        gaps_out = 12;
        border_size = 3;
        "col.active_border" = "rgba(2a2a2aa6)";
        "col.inactive_border" = "rgba(2a2a2a73)";
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 0.97;

        shadow = {
          enabled = true;
          range = 8;
          render_power = 2;
          color = "rgba(0, 0, 0, 0.7)";
        };

        blur = {
          enabled = true;
          size = 10;
          passes = 4;
          vibrancy = 1.0;
          new_optimizations = true;
          ignore_opacity = true;
          popups = true;
        };
      };

      animations = {
        enabled = true;

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 3, easeOutQuint, slide"
          "workspacesIn, 1, 3, easeOutQuint, slide"
          "workspacesOut, 1, 3, easeOutQuint, slide"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_autoreload = false;
        layers_hog_keyboard_focus = false;
      };

      input = {
        kb_layout = "us,ru,ua";
        kb_options = "grp:ctrl_space_toggle";
        follow_mouse = 2;
        sensitivity = -0.8;
        accel_profile = "flat";
        repeat_rate = 67;
        repeat_delay = 150;

        touchpad = {
          natural_scroll = false;
        };
      };

      device = {
        name = "wl-wlmouse-beast-max-8k-receiver-1";
        sensitivity = -0.6;
        accel_profile = "flat";
      };

      "$mainMod" = "SUPER";

      exec-once = [
        "quickshell"
        "swww-daemon"
        "swww img ~/.config/wallpapers/current"
        "hypridle"
        "hyprctl setcursor Bibata-Modern-Classic 24"
        "nm-applet --indicator"
        "bitwarden"
        "[workspace 1 silent] MOZ_ENABLE_WAYLAND=1 firefox"
        "[workspace 2 silent] ghostty"
        "[workspace 6 silent] telegram-desktop"
      ];

      bind = [
        "$mainMod, T, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, F, togglefloating,"
        "ALT, Space, exec, $menu"
        "ALT, Tab, focuscurrentorlast,"
        "$mainMod, P, pseudo,"
        "$mainMod, B, togglesplit,"
        '', Print, exec, grim -g "$(slurp)" - | wl-copy''
        "SHIFT, Print, exec, grim - | wl-copy"
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, l, movewindow, r"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, j, movewindow, d"
        "$mainMod, comma, focusmonitor, l"
        "$mainMod, period, focusmonitor, r"
        "$mainMod SHIFT, comma, movewindow, mon:l"
        "$mainMod SHIFT, period, movewindow, mon:r"
        "$mainMod CTRL, comma, movecurrentworkspacetomonitor, l"
        "$mainMod CTRL, period, movecurrentworkspacetomonitor, r"
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod, TAB, hyprexpo:expo, toggle"
        "$mainMod, N, exec, notify-send 'Test' 'Quickshell notification test'"
        "$mainMod, O, exec, echo 'test' > /tmp/quickshell-volume-trigger"
        "$mainMod, Escape, exec, hyprlock"
      ];

      bindd = [
        "$mainMod, C, Copy, sendshortcut, CTRL, Insert,"
        "$mainMod, V, Paste, sendshortcut, SHIFT, Insert,"
        "$mainMod, X, Cut, sendshortcut, CTRL, X,"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, pamixer -i 5 && touch /tmp/quickshell-volume-trigger"
        ",XF86AudioLowerVolume, exec, pamixer -d 5 && touch /tmp/quickshell-volume-trigger"
        ",XF86AudioMute, exec, pamixer -t && touch /tmp/quickshell-volume-trigger"
        ",XF86AudioMicMute, exec, pamixer --default-source -t"
        ",XF86MonBrightnessUp, exec, brightnessctl set +5% && touch /tmp/quickshell-brightness-trigger"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%- && touch /tmp/quickshell-brightness-trigger"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      bindr = [ ", Caps_Lock, exec, ~/.config/scripts/caps-lock-notify.sh" ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      layerrule = [
        "blur 1, match:namespace rofi"
        "ignore_alpha 0.2, match:namespace rofi"
        "blur 1, match:namespace quickshell"
        "ignore_alpha 0.1, match:namespace quickshell"
        "blur 1, match:namespace notifications"
        "ignore_alpha 0.2, match:namespace notifications"
        "blur 1, match:namespace osd"
        "ignore_alpha 0.2, match:namespace osd"
      ];

      windowrule = [
        "float on, match:class Bitwarden"
        "pin on, match:class Bitwarden"
        "size 900 700, match:class Bitwarden"
        "center 1, match:class Bitwarden"
        "workspace 1, match:class firefox"
        "workspace 2, match:class ghostty"
        "workspace 6, match:class telegram"
        "suppress_event maximize, match:class .*"
        "no_focus 1, match:class ^$, match:title ^$, match:xwayland 1"
      ];

      plugin = {
        hyprexpo = {
          columns = 3;
          gap_size = 10;
          bg_col = "rgb(080808)";
          workspace_method = "center current";

          enable_gesture = true;
          gesture_fingers = 3;
          gesture_distance = 300;
          gesture_positive = true;

          enable_on_activity = false;
          switch_on_close = true;
          exit_on_click = true;
          exit_on_escape = true;
        };
      };
    };
  };
}
