{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    waybar
    playerctl
    lm_sensors
    pamixer
    pavucontrol
    libappindicator-gtk3
    hicolor-icon-theme
    adwaita-icon-theme
  ];

  home.sessionVariables = {
    XDG_DATA_DIRS =
      "${pkgs.hicolor-icon-theme}/share:${pkgs.adwaita-icon-theme}/share:$XDG_DATA_DIRS";
  };

  home.file = {
    ".config/waybar/config.jsonc" = {
      text = ''
        {
          "layer": "top",
          "position": "top",
          "height": 30,
          "modules-left": ["custom/launcher", "hyprland/workspaces"],
          "modules-center": ["clock"],
          "modules-right": ["group/tray-expander", "cpu",  "network", "pulseaudio", "hyprland/language"],

          "hyprland/workspaces": {
            "rotate": 0,
            "class": "no-margin-padding",
            "all-outputs": true,
            "active-only": false,
            "on-click": "activate",
            "disable-scroll": false,
            "on-scroll-up": "hyprctl dispatch workspace -1",
            "on-scroll-down": "hyprctl dispatch workspace +1",
            "persistent-workspaces": {},
            "format": "{icon}",
            "format-icons": {
              "1": "",
              "2": "",
              "3": "",
              "4": "",
              "5": "",
              "6": "",
              "7": "",
              "8": "",
              "9": "",
              "10": "",
              "urgent": "",
              "focused": "",
              "default": "",
              "active": ""
            }
          },

          "custom/launcher": {
            "format": "  ",
            "on-click": "walker",
            "tooltip": false
          },
          
          "clock": {
            "format": "{:%a %m/%d/%Y ~ %H:%M}",
            "tooltip-format": "<tt><small>{calendar}</small></tt>",
            "calendar": {
              "mode": "year",
              "mode-mon-col": 3,
              "weeks-pos": "right",
              "on-scroll": 1,
              "format": {
                "months": "<span color='#ffead3'><b>{}</b></span>",
                "days": "<span color='#ecc6d9'><b>{}</b></span>",
                "weeks": "<span color='#99ffdd'><b>W{}</b></span>",
                "weekdays": "<span color='#ffcc66'><b>{}</b></span>",
                "today": "<span color='#ff6699'><b><u>{}</u></b></span>"
              }
            }
          },
          
          "cpu": {
            "format": "󰻠",
            "tooltip": true,
            "tooltip-format": "CPU Usage: {usage}%\nAverage load: {load}",
            "interval": 2
          },
          
          "pulseaudio": {
            "format": "{icon}",
            "on-click": "env PULSE_SERVER=unix:/run/user/1000/pulse/native pavucontrol",
            "on-click-right": "pamixer -t",
            "tooltip-format": "Playing at {volume}%",
            "scroll-step": 5,
            "format-muted": "",
            "format-icons": {
              "default": ["", "", ""]
            }
          },
          
          "network": {
            "format-wifi": "󰤨",
            "format-ethernet": "󰈀",
            "format-disconnected": "󰤭",
            "tooltip-format": "Network: {ifname}\nIP: {ipaddr}/{cidr}\nGateway: {gwaddr}",
            "tooltip-format-wifi": "WiFi: {essid} ({signalStrength}%)\nIP: {ipaddr}/{cidr}\nFrequency: {frequency}MHz",
            "on-click": "nm-connection-editor"
          },
          
          "battery": {
            "format": "{capacity}%"
          },
          
          "group/tray-expander": {
            "orientation": "inherit",
            "drawer": {
              "transition-duration": 600,
              "children-class": "tray-group-item"
            },
            "modules": ["custom/expand-icon", "tray"]
          },

          "custom/expand-icon": {
            "format": "󰀻",
            "tooltip": false
          },

          "tray": {
            "icon-size": 16,
            "spacing": 10,
            "show-passive-items": true
          },

          "hyprland/language": {
            "format": "{}",
            "format-en": "EN",
            "format-ru": "RU",
            "format-uk": "UA",
            "keyboard-name": "wooting-wooting-80he",
            "on-click": "hyprctl switchxkblayout wooting-wooting-80he next"
          }
        }
      '';
      force = true;
    };

    ".config/waybar/style.css" = {
      text = ''
        * {
          font-family: "BerkeleyMonoMinazuki Nerd Font";
          font-size: 13px;
          border: none;
          border-radius: 0;
          min-height: 0;
        }

        window#waybar {
          background: #080808;
          border-bottom: 3px solid rgba(25, 25, 25, 0.15);
          padding: 5px;
          color: white;
          box-shadow: 0 8px 8px rgba(0, 0, 0, 0.3);
        }

        #workspaces button {
          box-shadow: none;
          text-shadow: none;
          padding: 0em;
          margin-top: 0.3em;
          margin-bottom: 0.3em;
          margin-left: 0em;
          padding-left: 0.3em;
          padding-right: 0.3em;
          margin-right: 0em;
          color: #DDD;
          background: transparent;
          border: 3px solid rgba(25, 25, 25, 0.15);
          border-radius: 8px;
        }

        #workspaces button.active {
          background: #DDD;
          color: #080808;
          margin-left: 0.3em;
          padding-left: 1.2em;
          padding-right: 1.2em;
          margin-right: 0.3em;
          border: 3px solid rgba(25, 25, 25, 0.26);
          transition: all 0.4s cubic-bezier(.55, -0.68, .48, 1.682);
          border-radius: 8px;
        }

        #workspaces button.urgent {
          color: #ffaa88;
          background: transparent;
          border: 3px solid rgba(255, 170, 136, 0.5);
        }

        #custom-launcher {
          padding: 0 10px;
          font-size: 18px;
          color: #DDD;
        }

        #custom-launcher:hover {
          background: rgba(25, 25, 25, 0.26);
          border-radius: 6px;
        }

        #clock, #battery {
          padding: 0 10px;
        }

        #pulseaudio {
          padding: 0 10px;
          font-size: 20px;
        }

        #pulseaudio.muted {
          color: #888;
        }

        #cpu {
          color: #DDD;
          font-weight: bold;
          font-size: 20px;
          padding: 0 10px;
        }

        #network {
          font-size: 20px;
          padding: 0 10px;
        }

        #battery {
          font-size: 13px;
        }

        #language {
          font-size: 13px;
          padding: 0 10px;
        }

        #tray {
          padding: 0 10px;
        }

        #tray > .item {
          padding: 0 5px;
        }

        #custom-expand-icon {
          font-size: 16px;
          padding: 0 5px;
        }

        .tray-group-item {
          background: rgba(25, 25, 25, 0.15);
          border-radius: 6px;
          padding: 0 2px;
        }
      '';
      force = true;
    };

  };
}

