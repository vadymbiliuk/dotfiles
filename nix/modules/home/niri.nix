{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) getExe;

  grim = getExe pkgs.grim;
  slurp = getExe pkgs.slurp;
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
  wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";
  swappy = getExe pkgs.swappy;
  pamixer = getExe pkgs.pamixer;
  playerctl = getExe pkgs.playerctl;
  brightnessctl = getExe pkgs.brightnessctl;
  swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
  swww = "${pkgs.awww}/bin/awww";
  swww-daemon = "${pkgs.awww}/bin/awww-daemon";
in
{
  xdg.configFile."niri/config.kdl".text = ''
    hotkey-overlay {
        skip-at-startup
    }

    input {
        keyboard {
            xkb {
                layout "us,ru,ua"
                options "grp:alt_shift_toggle"
            }
            repeat-rate 67
            repeat-delay 150
        }

        mouse {
            accel-profile "flat"
            accel-speed -0.6
        }

        touchpad {
            tap
            natural-scroll
        }
    }

    output "ASUSTek COMPUTER INC XG27AQDPG T7LMAS018552" {
        mode "2560x1440@500.000"
        position x=1440 y=730
    }

    layout {
        gaps 8

        focus-ring {
            width 3
            active-color "#2a2a2aa6"
            inactive-color "#2a2a2a73"
        }

        border {
            off
        }

        default-column-width { proportion 1.0; }
    }

    prefer-no-csd

    window-rule {
        geometry-corner-radius 10
        clip-to-geometry true

        background-effect {
            blur true
            noise 0.05
            saturation 1.5
        }
    }

    cursor {
        xcursor-theme "Bibata-Modern-Classic"
        xcursor-size 24
    }

    environment {
        XCURSOR_SIZE "24"
        XCURSOR_THEME "Bibata-Modern-Classic"
        DISPLAY ":0"
    }

    workspace "1" {
        open-on-output "ASUSTek COMPUTER INC XG27AQDPG T7LMAS018552"
    }
    workspace "2" {
        open-on-output "ASUSTek COMPUTER INC XG27AQDPG T7LMAS018552"
    }
    workspace "3" {
        open-on-output "ASUSTek COMPUTER INC XG27AQDPG T7LMAS018552"
    }
    workspace "4" {
        open-on-output "ASUSTek COMPUTER INC XG27AQDPG T7LMAS018552"
    }
    workspace "5" {
        open-on-output "ASUSTek COMPUTER INC XG27AQDPG T7LMAS018552"
    }
    workspace "6" {
        open-on-output "DP-2"
    }
    workspace "7" {
        open-on-output "DP-2"
    }
    workspace "8" {
        open-on-output "DP-2"
    }
    workspace "9" {
        open-on-output "DP-2"
    }
    workspace "10" {
        open-on-output "DP-2"
    }

    window-rule {
        match app-id=r#"(?i)bitwarden"#
        open-fullscreen false
        open-maximized false
        open-floating true
        default-column-width { fixed 900; }
        default-window-height { fixed 900; }
    }

    window-rule {
        match app-id=r#"^firefox$"#
        open-on-workspace "1"
        open-maximized false
    }

    window-rule {
        match app-id=r#"^kitty$"#
        open-on-workspace "2"
    }

    window-rule {
        match app-id=r#"^org\.telegram\.desktop$"#
        open-on-workspace "7"
    }

    window-rule {
        match app-id=r#"^discord$"#
        open-on-workspace "3"
    }

    window-rule {
        match app-id=r#"^steam$"#
        open-on-workspace "3"
    }

    window-rule {
        match app-id=r#"^steam_app_"#
        open-on-workspace "3"
        open-fullscreen true
    }

    window-rule {
        match app-id=r#"^thunderbird$"#
        open-on-workspace "5"
    }

    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "noctalia-shell"
    spawn-at-startup "${swww-daemon}"
    spawn-at-startup "sh" "-c" "sleep 2 && ${swww} img ${config.home.homeDirectory}/.config/wallpapers/wallpaper.jpg"
    spawn-at-startup "nm-applet" "--indicator"
    spawn-at-startup "nordvpn" "connect" "Germany"
    spawn-at-startup "firefox"
    spawn-at-startup "kitty"
    spawn-at-startup "telegram-desktop"
    spawn-at-startup "sh" "-c" "sleep 1 && steam"
    spawn-at-startup "discord"
    spawn-at-startup "thunderbird"

    animations {
        window-open {
            duration-ms 200
            curve "ease-out-expo"
        }

        window-close {
            duration-ms 150
            curve "ease-out-expo"
        }

        workspace-switch {
            duration-ms 300
            curve "ease-out-expo"
        }

        horizontal-view-movement {
            duration-ms 300
            curve "ease-out-expo"
        }

        config-notification-open-close {
            duration-ms 200
            curve "ease-out-expo"
        }
    }

    binds {
        Mod+T { spawn "kitty"; }
        Mod+Q { close-window; }
        Mod+E { spawn "pcmanfm"; }

        Mod+F { maximize-column; }
        Mod+G { fullscreen-window; }
        Mod+Shift+F { toggle-window-floating; }
        Mod+C { center-column; }

        Alt+Space { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }

        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+K { focus-window-or-workspace-up; }
        Mod+J { focus-window-or-workspace-down; }

        Mod+Left { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Up { focus-window-or-workspace-up; }
        Mod+Down { focus-window-or-workspace-down; }

        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+K { move-window-up-or-to-workspace-up; }
        Mod+Shift+J { move-window-down-or-to-workspace-down; }

        Mod+Comma { focus-monitor-left; }
        Mod+Period { focus-monitor-right; }
        Mod+Shift+Comma { move-column-to-monitor-left; }
        Mod+Shift+Period { move-column-to-monitor-right; }
        Mod+Ctrl+Comma { move-workspace-to-monitor-left; }
        Mod+Ctrl+Period { move-workspace-to-monitor-right; }

        Mod+1 { focus-workspace "1"; }
        Mod+2 { focus-workspace "2"; }
        Mod+3 { focus-workspace "3"; }
        Mod+4 { focus-workspace "4"; }
        Mod+5 { focus-workspace "5"; }
        Mod+6 { focus-workspace "6"; }
        Mod+7 { focus-workspace "7"; }
        Mod+8 { focus-workspace "8"; }
        Mod+9 { focus-workspace "9"; }
        Mod+0 { focus-workspace "10"; }

        Mod+Shift+1 { move-column-to-workspace "1"; }
        Mod+Shift+2 { move-column-to-workspace "2"; }
        Mod+Shift+3 { move-column-to-workspace "3"; }
        Mod+Shift+4 { move-column-to-workspace "4"; }
        Mod+Shift+5 { move-column-to-workspace "5"; }
        Mod+Shift+6 { move-column-to-workspace "6"; }
        Mod+Shift+7 { move-column-to-workspace "7"; }
        Mod+Shift+8 { move-column-to-workspace "8"; }
        Mod+Shift+9 { move-column-to-workspace "9"; }
        Mod+Shift+0 { move-column-to-workspace "10"; }

        Mod+Ctrl+H { set-column-width "-5%"; }
        Mod+Ctrl+L { set-column-width "+5%"; }
        Mod+Ctrl+K { set-window-height "+5%"; }
        Mod+Ctrl+J { set-window-height "-5%"; }

        Mod+WheelScrollDown { focus-column-left; }
        Mod+WheelScrollUp { focus-column-right; }
        Mod+Ctrl+WheelScrollDown { focus-workspace-down; }
        Mod+Ctrl+WheelScrollUp { focus-workspace-up; }

        Print { spawn "sh" "-c" "${grim} -g \"$(${slurp})\" - | ${wl-copy}"; }
        Shift+Print { spawn "sh" "-c" "${grim} - | ${wl-copy}"; }
        Mod+Shift+E { spawn "sh" "-c" "${wl-paste} | ${swappy} -f -"; }

        XF86AudioRaiseVolume allow-when-locked=true { spawn "${pamixer}" "-i" "5"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "${pamixer}" "-d" "5"; }
        XF86AudioMute allow-when-locked=true { spawn "${pamixer}" "-t"; }
        XF86AudioMicMute { spawn "${pamixer}" "--default-source" "-t"; }
        XF86MonBrightnessUp { spawn "${brightnessctl}" "set" "+5%"; }
        XF86MonBrightnessDown { spawn "${brightnessctl}" "set" "5%-"; }
        XF86AudioNext allow-when-locked=true { spawn "${playerctl}" "next"; }
        XF86AudioPause allow-when-locked=true { spawn "${playerctl}" "play-pause"; }
        XF86AudioPlay allow-when-locked=true { spawn "${playerctl}" "play-pause"; }
        XF86AudioPrev allow-when-locked=true { spawn "${playerctl}" "previous"; }

        Mod+Escape { spawn "${swaylock}"; }

        Mod+Shift+M { quit; }
    }
  '';
}
