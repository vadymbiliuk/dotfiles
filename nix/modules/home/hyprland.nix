{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    swaynotificationcenter
    swayosd
    hyprlandPlugins.hyprexpo
  ];

  services.mako.enable = false;

  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "user";
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      control-center-margin-left = 10;
      notification-2fa-action = true;
      notification-inline-replies = false;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      fit-to-screen = true;
      control-center-width = 500;
      control-center-height = 600;
      notification-window-width = 500;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;
      widgets = [ "inhibitors" "title" "dnd" "notifications" ];
      widget-config = {
        inhibitors = {
          text = "Inhibitors";
          button-text = "Clear All";
          clear-all-button = true;
        };
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd = { text = "Do Not Disturb"; };
      };
    };
    style = ''
      @define-color noti-bg rgba(8, 8, 8, 0.85);
      @define-color text-color #DDD;

      .notification {
        background: @noti-bg;
        border: 3px solid rgba(42, 42, 42, 0.65);
        border-radius: 10px;
        margin: 6px 12px;
        padding: 10px;
      }

      .notification:hover {
        background: @noti-bg;
      }

      .notification-window {
        background: @noti-bg;
      }

      .floating-notifications .notification {
        background: @noti-bg;
      }

      .control-center {
        background: @noti-bg;
        border-radius: 10px;
        margin: 12px;
      }

      .control-center-list .notification:hover {
        background: @noti-bg;
      }

      .mpris-background {
        background: @noti-bg;
      }
    '';
  };

  services.swayosd = {
    enable = true;
    topMargin = 0.5;
    stylePath = pkgs.writeText "swayosd-style.css" ''
      .osd-window {
        padding: 12px 20px;
        border-radius: 10px;
        border: 3px solid rgba(42, 42, 42, 0.65);
        background: rgba(18, 18, 18, 0.97);
      }

      .container {
        margin: 16px;
        border-radius: 10px;
      }

      .osd-text {
        font-family: "BerkeleyMonoMinazuki Nerd Font Mono";
        font-size: 11pt;
        color: rgba(138, 138, 141, 1);
      }

      .osd-image {
        color: rgba(138, 138, 141, 1);
        margin-right: 6px;
      }

      .level-bar {
        border-radius: 10px;
      }

      .level-bar trough {
        min-height: 6px;
        border-radius: 10px;
        background: rgba(138, 138, 141, 0.15);
      }

      .level-bar block {
        min-height: 6px;
        border-radius: 10px;
        background: rgba(138, 138, 141, 1);
      }

      .level-bar block.filled {
        background: rgba(138, 138, 141, 1);
      }

      .level-bar block.empty {
        background: rgba(138, 138, 141, 0.15);
      }
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [ pkgs.hyprlandPlugins.hyprexpo ];
    settings = {
      monitor = "DP-2,2560x1440@359.98,0x0,1";

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

      master = { new_status = "master"; };

      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
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

        touchpad = { natural_scroll = false; };
      };

      device = {
        name = "wl-wlmouse-beast-max-8k-receiver-1";
        sensitivity = -0.6;
        accel_profile = "flat";
      };

      "$mainMod" = "SUPER";

      exec-once = [
        "waybar"
        "hyprpaper"
        "hyprctl setcursor Bibata-Modern-Classic 24"
        "1password --silent-launch --ozone-platform-hint=x11"
        "swaync"
        "swayosd-server"
        "[workspace 1 silent] firefox"
        "[workspace 2 silent] ghostty"
        "[workspace 3 silent] telegram-desktop"
      ];

      bind = [
        "$mainMod, T, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, F, togglefloating,"
        "ALT, Space, exec, $menu"
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
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod, TAB, hyprexpo:expo, toggle"
        "$mainMod, N, exec, swaync-client -t -sw"
        "$mainMod SHIFT, N, exec, swaync-client -d -sw"
        "$mainMod ALT, N, exec, swaync-client -C"
      ];

      bindd = [
        "$mainMod, C, Copy, sendshortcut, CTRL, Insert,"
        "$mainMod, V, Paste, sendshortcut, SHIFT, Insert,"
        "$mainMod, X, Cut, sendshortcut, CTRL, X,"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        ",XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
        ",XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        ",XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
        ",XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
        ",XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
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

      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];

      layerrule = [
        "blur, rofi"
        "ignorealpha 0.2, rofi"
        "blur, swaync-control-center"
        "blur, swaync-notification-window"
        "ignorezero, swaync-control-center"
        "ignorezero, swaync-notification-window"
        "ignorealpha 0.5, swaync-control-center"
        "ignorealpha 0.5, swaync-notification-window"
      ];

      windowrulev2 = [
        "workspace 1,class:^(firefox)$"
        "workspace 2,class:^(ghostty)$"
        "workspace 3,class:^(org.telegram.desktop)$"
        "float,class:^(1Password)$"
        "size 700 500,class:^(1Password)$"
        "center,class:^(1Password)$"
        "pin,class:^(1Password)$"
        "noanim,class:^(1Password)$"
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
