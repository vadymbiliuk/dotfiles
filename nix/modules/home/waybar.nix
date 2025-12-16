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
          "modules-right": ["privacy", "group/tray-expander", "custom/weather", "temperature", "pulseaudio", "network", "hyprland/language"],

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
            "on-click": "rofi -show drun",
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
          
         "pulseaudio": {
            // "scroll-step": 1, // %, can be a float
            "reverse-scrolling": 1,
            "format": "{icon} {volume}% {format_source}",
            "format-bluetooth": "{icon} {volume}% {format_source}",
            "format-bluetooth-muted": "{icon}  {format_source}",
            "format-muted": "󰖁 {format_source}",
            "format-source": "󰍬 {volume}%",
            "format-source-muted": "󰍭",
            "format-icons": {
                "headphone": "󰋋",
                "hands-free": "󱡏",
                "headset": "󰋎",
                "phone": "󰏲",
                "portable": "󰦢",
                "car": "󰄋",
                "default": ["󰕿", "󰖀", "󰕾"]
            },
            "tooltip": true,
            "tooltip-format": "Output: {desc}\nVolume: {volume}%\nInput: {source_desc}\nInput Volume: {source_volume}%",
            "on-click": "pavucontrol",
            "min-length": 13,
          }, 

          "network": {
            "format-wifi": "WiFi",
            "format-ethernet": "Ethernet",
            "format-disconnected": "Disconnected",
            "tooltip-format": "Network: {ifname}\nIP: {ipaddr}/{cidr}\nGateway: {gwaddr}",
            "tooltip-format-wifi": "WiFi: {essid} ({signalStrength}%)\nIP: {ipaddr}/{cidr}\nFrequency: {frequency}MHz",
            "on-click": "nm-connection-editor"
          },

          "temperature": {
              "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
              "critical-threshold": 80,
              "format": "{icon} {temperatureC}°C",
              "format-icons": ["󱃃", "󰔏", "󱃂", "󰸁", "󰈸"],
              "tooltip": true,
              "tooltip-format": "CPU Temperature: {temperatureC}°C",
              "on-click": "ghostty -e btop",
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
          },

          "custom/weather": {
            "format": "{}",
            "tooltip": true,
            "interval": 1800,
            "exec": "$HOME/.config/waybar/scripts/wttr.py",
            "return-type": "json",
            "on-click": "xdg-open https://wttr.in/Kyiv"
          },

          "privacy": {
            "icon-spacing": 4,
            "icon-size": 18,
            "transition-duration": 250,
            "modules": [
              {
                "type": "screenshare",
                "tooltip": true,
                "tooltip-icon-size": 24
              },
              {
                "type": "audio-in",
                "tooltip": true,
                "tooltip-icon-size": 24
              }
            ]
          }
        }
      '';
      force = true;
    };

    ".config/waybar/style.css" = {
      text = ''
        * {
          font-family: "BerkeleyMonoMinazuki Nerd Font Mono";
          font-size: 16px;
          border: none;
          border-radius: 0;
          min-height: 0;
          margin: 0;
          padding: 0 5px;
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

        #workspaces {
          padding: 0;
        }

        #network {
          padding: 0;
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
          color: #DDD;
          font-size: 20px;
        }

        #custom-launcher:hover {
          background: rgba(25, 25, 25, 0.26);
          border-radius: 6px;
        }

        #pulseaudio,
        #temperature,
        #network,
        #custom-weather {
          min-width: 40px;
        }

        #temperature .format-icons,
        #pulseaudio .format-icons {
          font-family: "BerkeleyMonoMinazuki Nerd Font Mono";
          font-size: 16px;
          min-width: 20px;
        }

        #privacy-item.screenshare {
          color: #ff6b6b;
        }

        #privacy-item.audio-in {
          color: #4ecdc4;
        }
      '';
      force = true;
    };

    ".config/waybar/scripts/wttr.py" = {
      text = ''
        #!${
          pkgs.python312.withPackages (ps: with ps; [ requests ])
        }/bin/python3.12

        import json
        import requests
        from datetime import datetime

        WEATHER_CODES = {
            '113': '☀️',
            '116': '⛅️',
            '119': '☁️',
            '122': '☁️',
            '143': '🌫',
            '176': '🌦',
            '179': '🌧',
            '182': '🌧',
            '185': '🌧',
            '200': '⛈',
            '227': '🌨',
            '230': '❄️',
            '248': '🌫',
            '260': '🌫',
            '263': '🌦',
            '266': '🌦',
            '281': '🌧',
            '284': '🌧',
            '293': '🌦',
            '296': '🌦',
            '299': '🌧',
            '302': '🌧',
            '305': '🌧',
            '308': '🌧',
            '311': '🌧',
            '314': '🌧',
            '317': '🌧',
            '320': '🌨',
            '323': '🌨',
            '326': '🌨',
            '329': '❄️',
            '332': '❄️',
            '335': '❄️',
            '338': '❄️',
            '350': '🌧',
            '353': '🌦',
            '356': '🌧',
            '359': '🌧',
            '362': '🌧',
            '365': '🌧',
            '368': '🌨',
            '371': '❄️',
            '374': '🌧',
            '377': '🌧',
            '386': '⛈',
            '389': '🌩',
            '392': '⛈',
            '395': '❄️'
        }

        data = {}

        weather = requests.get("https://wttr.in/Kyiv?format=j1").json()

        def format_time(time):
            return time.replace("00", "").zfill(2)

        def format_temp(temp):
            return (hour['FeelsLikeC']+"°").ljust(3)

        def format_chances(hour):
            chances = {
                "chanceoffog": "Fog",
                "chanceoffrost": "Frost",
                "chanceofovercast": "Overcast",
                "chanceofrain": "Rain",
                "chanceofsnow": "Snow",
                "chanceofsunshine": "Sunshine",
                "chanceofthunder": "Thunder",
                "chanceofwindy": "Wind"
            }

            conditions = []
            for event in chances.keys():
                if int(hour[event]) > 0:
                    conditions.append(chances[event]+" "+hour[event]+"%")
            return ", ".join(conditions)

        data['text'] = WEATHER_CODES[weather['current_condition'][0]['weatherCode']] + \
            " " + weather['current_condition'][0]['FeelsLikeC']+ "°"

        data['tooltip'] = f"<b>{weather['current_condition'][0]['weatherDesc'][0]['value']} {weather['current_condition'][0]['temp_C']}°</b>\n"
        data['tooltip'] += f"Feels like: {weather['current_condition'][0]['FeelsLikeC']}°\n"
        data['tooltip'] += f"Wind: {weather['current_condition'][0]['windspeedKmph']}Km/h\n"
        data['tooltip'] += f"Humidity: {weather['current_condition'][0]['humidity']}%\n"
        for i, day in enumerate(weather['weather']):
            data['tooltip'] += f"\n<b>"
            if i == 0:
                data['tooltip'] += "Today, "
            if i == 1:
                data['tooltip'] += "Tomorrow, "
            data['tooltip'] += f"{day['date']}</b>\n"
            data['tooltip'] += f"⬆️ {day['maxtempC']}° ⬇️ {day['mintempC']}° "
            data['tooltip'] += f" {day['astronomy'][0]['sunrise']}  {day['astronomy'][0]['sunset']}\n"
            for hour in day['hourly']:
                if i == 0:
                    if int(format_time(hour['time'])) < datetime.now().hour-2:
                        continue
                data['tooltip'] += f"{format_time(hour['time'])} {WEATHER_CODES[hour['weatherCode']]} {format_temp(hour['FeelsLikeC'])} {hour['weatherDesc'][0]['value']}, {format_chances(hour)}\n"

        print(json.dumps(data))
      '';
      executable = true;
    };

  };
}

