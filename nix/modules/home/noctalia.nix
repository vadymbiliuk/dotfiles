{ pkgs, lib, inputs, ... }:

let
  noctalia-plugins = inputs.noctalia-plugins;

  colorScheme = builtins.toJSON {
    dark = {
      mPrimary = "#aaaaaa";
      mOnPrimary = "#0a0a0a";
      mSecondary = "#888888";
      mOnSecondary = "#0a0a0a";
      mTertiary = "#b0b0b0";
      mOnTertiary = "#0a0a0a";
      mError = "#555555";
      mOnError = "#deeeed";
      mSurface = "#0a0a0a";
      mOnSurface = "#deeeed";
      mSurfaceVariant = "#191919";
      mOnSurfaceVariant = "#7a7a7a";
      mOutline = "#2a2a2a";
      mShadow = "#000000";
      mHover = "#aaaaaa";
      mOnHover = "#0a0a0a";
      terminal = {
        foreground = "#deeeed";
        background = "#0a0a0a";
        selectionFg = "#e0e0e0";
        selectionBg = "#3a3f4b";
        cursorText = "#0a0a0a";
        cursor = "#d6d6d6";
        normal = {
          black = "#1c1e23";
          red = "#555555";
          green = "#5e5e5e";
          yellow = "#666666";
          blue = "#6e6e6e";
          magenta = "#777777";
          cyan = "#7f7f7f";
          white = "#b0b0b0";
        };
        bright = {
          black = "#2b2e34";
          red = "#888888";
          green = "#8f8f8f";
          yellow = "#999999";
          blue = "#a2a2a2";
          magenta = "#ababab";
          cyan = "#b5b5b5";
          white = "#d6d6d6";
        };
      };
    };
    light = {
      mPrimary = "#555555";
      mOnPrimary = "#f0f0f0";
      mSecondary = "#777777";
      mOnSecondary = "#f0f0f0";
      mTertiary = "#444444";
      mOnTertiary = "#f0f0f0";
      mError = "#999999";
      mOnError = "#f0f0f0";
      mSurface = "#dddddd";
      mOnSurface = "#191919";
      mSurfaceVariant = "#e8e8e8";
      mOnSurfaceVariant = "#555555";
      mOutline = "#cccccc";
      mShadow = "#fafafa";
      mHover = "#555555";
      mOnHover = "#f0f0f0";
      terminal = {
        foreground = "#191919";
        background = "#dddddd";
        selectionFg = "#e0e0e0";
        selectionBg = "#555555";
        cursorText = "#dddddd";
        cursor = "#555555";
        normal = {
          black = "#e8e8e8";
          red = "#999999";
          green = "#8f8f8f";
          yellow = "#888888";
          blue = "#777777";
          magenta = "#666666";
          cyan = "#555555";
          white = "#191919";
        };
        bright = {
          black = "#cccccc";
          red = "#aaaaaa";
          green = "#a2a2a2";
          yellow = "#999999";
          blue = "#888888";
          magenta = "#777777";
          cyan = "#666666";
          white = "#000000";
        };
      };
    };
  };

  privacyIndicatorSettings = builtins.toJSON {
    activeIconColor = "#deeeed";
  };

  pluginsJson = pkgs.writeText "plugins.json" (builtins.toJSON {
    version = 1;
    sources = [
      {
        enabled = true;
        name = "Official Noctalia Plugins";
        url = "https://github.com/noctalia-dev/noctalia-plugins";
      }
    ];
    states = {
      weather-indicator = {
        enabled = true;
        sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
      };
      hyprland-steam-overlay = {
        enabled = true;
        sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
      };
      tailscale = {
        enabled = true;
        sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
      };
      privacy-indicator = {
        enabled = true;
        sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
      };
      polkit-agent = {
        enabled = true;
        sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
      };
    };
  });
in
{
  home.file = {
    ".config/noctalia/colorschemes/ZookiMono/ZookiMono.json".text = colorScheme;
    ".config/noctalia/plugins.json".source = pluginsJson;
    ".config/noctalia/plugins/weather-indicator" = {
      source = "${noctalia-plugins}/weather-indicator";
      recursive = true;
    };
    ".config/noctalia/plugins/hyprland-steam-overlay" = {
      source = "${noctalia-plugins}/hyprland-steam-overlay";
      recursive = true;
    };
    ".config/noctalia/plugins/tailscale" = {
      source = "${noctalia-plugins}/tailscale";
      recursive = true;
    };
    ".config/noctalia/plugins/privacy-indicator" = {
      source = "${noctalia-plugins}/privacy-indicator";
      recursive = true;
    };
    ".config/noctalia/plugins/privacy-indicator/settings.json".text = privacyIndicatorSettings;
    ".config/noctalia/plugins/polkit-agent" = {
      source = "${noctalia-plugins}/polkit-agent";
      recursive = true;
    };
  };
}
