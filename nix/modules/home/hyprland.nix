{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  inherit (lib) getExe;

  mod = "SUPER";

  bitwardenPopupHandler = pkgs.writeShellScript "bitwarden-popup-handler" ''
    handle_windowtitlev2() {
      windowaddress=''${1%,*}
      windowtitle=''${1#*,}

      case $windowtitle in
        *"(Bitwarden"*"Password Manager) - Bitwarden"*)
          hyprctl --batch \
            "dispatch setfloating address:0x$windowaddress;" \
            "dispatch resizewindowpixel exact 20% 50%,address:0x$windowaddress;" \
            "dispatch centerwindow"
          ;;
      esac
    }

    handle() {
      event=''${1%>>*}
      data=''${1#*>>}
      case $event in
        windowtitlev2) handle_windowtitlev2 "$data";;
      esac
    }

    ${getExe pkgs.socat} -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock \
      | while read -r line; do handle "$line"; done
  '';

  toWSNumber = n:
    toString (
      if n == 0
      then 10
      else n
    );

  workspaces = map (n: "${mod}, ${toString n}, workspace, ${toWSNumber n}") [1 2 3 4 5 6 7 8 9 0];
  moveToWorkspaces = map (n: "${mod} SHIFT, ${toString n}, movetoworkspace, ${toWSNumber n}") [1 2 3 4 5 6 7 8 9 0];
in
{
  services.mako.enable = false;

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    plugins = [ inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprscrolling ];
    settings = {
      monitor = [
        "desc:ASUSTek COMPUTER INC XG27AQDPG,2560x1440@500,1440x730,1"
        "desc:ASUSTek COMPUTER INC XG27ACDNG,2560x1440@359.98,0x0,1,transform,1"
      ];

      workspace = [
        "1, monitor:desc:ASUSTek COMPUTER INC XG27AQDPG, default:true"
        "2, monitor:desc:ASUSTek COMPUTER INC XG27AQDPG"
        "3, monitor:desc:ASUSTek COMPUTER INC XG27AQDPG"
        "4, monitor:desc:ASUSTek COMPUTER INC XG27AQDPG"
        "5, monitor:desc:ASUSTek COMPUTER INC XG27AQDPG"
        "6, monitor:desc:ASUSTek COMPUTER INC XG27ACDNG, layoutopt:orientation:top"
        "7, monitor:desc:ASUSTek COMPUTER INC XG27ACDNG, layoutopt:orientation:top"
        "8, monitor:desc:ASUSTek COMPUTER INC XG27ACDNG, layoutopt:orientation:top"
        "9, monitor:desc:ASUSTek COMPUTER INC XG27ACDNG, layoutopt:orientation:top"
        "10, monitor:desc:ASUSTek COMPUTER INC XG27ACDNG, layoutopt:orientation:top"
      ];

      "$terminal" = "ghostty";
      "$fileManager" = "pcmanfm";
      "$menu" = "noctalia-shell ipc call launcher toggle";

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "XCURSOR_THEME,Bibata-Modern-Classic"
      ];

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

      cursor = {
        no_warps = false;
        hotspot_padding = 0;
        no_hardware_cursors = 2;
      };

      device = {
        name = "wl-wlmouse-beast-max-8k-receiver-1";
        sensitivity = -0.6;
        accel_profile = "flat";
      };

      general = {
        gaps_in = 8;
        gaps_out = 12;
        border_size = 3;
        "col.active_border" = "rgba(2a2a2aa6)";
        "col.inactive_border" = "rgba(2a2a2a73)";
        resize_on_border = true;
        allow_tearing = false;
        layout = "scrolling";
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

      exec-once = [
        "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent"
        "noctalia-shell"
        "${bitwardenPopupHandler}"
        "${pkgs.swww}/bin/swww-daemon &"
        "${pkgs.swww}/bin/swww img ~/.config/wallpapers/wallpaper.jpg"
        # "hypridle"
        "hyprctl setcursor Bibata-Modern-Classic 24"
        "nm-applet --indicator"
        "bitwarden"
        "[workspace 1 silent] MOZ_ENABLE_WAYLAND=1 firefox"
        "[workspace 2 silent] ghostty"
        "[workspace 6 silent] telegram-desktop"
      ];

      bind =
        [
          "${mod}, T, exec, $terminal"
          "${mod}, Q, killactive,"
          "${mod}, M, exit,"
          "${mod}, E, exec, $fileManager"
          "${mod}, F, togglefloating,"
          "ALT, Space, exec, $menu"
          "ALT, Tab, focuscurrentorlast,"
          "${mod}, P, pseudo,"
          "${mod}, B, togglesplit,"

          '', Print, exec, grim -g "$(slurp)" - | wl-copy''
          "SHIFT, Print, exec, grim - | wl-copy"

          "${mod}, h, movefocus, l"
          "${mod}, l, movefocus, r"
          "${mod}, k, movefocus, u"
          "${mod}, j, movefocus, d"

          "${mod} SHIFT, h, movewindow, l"
          "${mod} SHIFT, l, movewindow, r"
          "${mod} SHIFT, k, movewindow, u"
          "${mod} SHIFT, j, movewindow, d"

          "${mod}, comma, focusmonitor, l"
          "${mod}, period, focusmonitor, r"
          "${mod} SHIFT, comma, movewindow, mon:l"
          "${mod} SHIFT, period, movewindow, mon:r"
          "${mod} CTRL, comma, movecurrentworkspacetomonitor, l"
          "${mod} CTRL, period, movecurrentworkspacetomonitor, r"

          "${mod}, S, togglespecialworkspace, magic"
          "${mod} SHIFT, S, movetoworkspace, special:magic"

          "${mod}, mouse_down, workspace, e+1"
          "${mod}, mouse_up, workspace, e-1"
          "${mod}, Escape, exec, hyprlock"
        ]
        ++ workspaces
        ++ moveToWorkspaces;

      bindel = [
        ",XF86AudioRaiseVolume, exec, pamixer -i 5"
        ",XF86AudioLowerVolume, exec, pamixer -d 5"
        ",XF86AudioMute, exec, pamixer -t"
        ",XF86AudioMicMute, exec, pamixer --default-source -t"
        ",XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];


      bindm = [
        "${mod}, mouse:272, movewindow"
        "${mod}, mouse:273, resizewindow"
      ];

      layerrule = [
        "blur 1, match:namespace rofi"
        "ignore_alpha 0.2, match:namespace rofi"
        "blur 1, match:namespace ^noctalia-background-.*$"
        "ignore_alpha 0.5, match:namespace ^noctalia-background-.*$"
      ];

      plugin = {
        hyprscrolling = {
          column_width = 0.5;
          fullscreen_on_one_column = false;
          focus_fit_method = 0;
          follow_focus = true;
        };
      };

      windowrule = [
        "render_unfocused on, match:class .*"
        "float on, match:class Bitwarden"
        "pin on, match:class Bitwarden"
        "size 900 700, match:class Bitwarden"
        "center 1, match:class Bitwarden"
        "workspace 1, match:class firefox"
        "workspace 2, match:class ghostty"
        "workspace 6, match:class telegram"
        "suppress_event maximize, match:class .*"
        "no_focus 1, match:class ^$, match:title ^$, match:xwayland 1"
        "monitor desc:ASUSTek COMPUTER INC XG27AQDPG, match:class ^steam_app_.*$"
        "fullscreen on, match:class ^steam_app_.*$"
        "workspace 4, match:class ^steam_app_.*$"
      ];

    };
  };
}
