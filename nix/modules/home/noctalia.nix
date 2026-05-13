{ pkgs, lib, inputs, ... }:

let
  theme = import ../themes/monochrome.nix;
  c = theme.colors;
  noctalia-plugins = inputs.noctalia-plugins;

  colorScheme = builtins.toJSON {
    dark = {
      mPrimary = c.dark.primary;
      mOnPrimary = c.dark.onPrimary;
      mSecondary = c.dark.secondary;
      mOnSecondary = c.dark.onSecondary;
      mTertiary = c.dark.tertiary;
      mOnTertiary = c.dark.onTertiary;
      mError = c.dark.error;
      mOnError = c.dark.onError;
      mSurface = c.dark.surface;
      mOnSurface = c.dark.onSurface;
      mSurfaceVariant = c.dark.surfaceVariant;
      mOnSurfaceVariant = c.dark.onSurfaceVariant;
      mOutline = c.dark.outline;
      mShadow = c.dark.shadow;
      mHover = c.dark.hover;
      mOnHover = c.dark.onHover;
      terminal = c.dark.terminal;
    };
    light = {
      mPrimary = c.light.primary;
      mOnPrimary = c.light.onPrimary;
      mSecondary = c.light.secondary;
      mOnSecondary = c.light.onSecondary;
      mTertiary = c.light.tertiary;
      mOnTertiary = c.light.onTertiary;
      mError = c.light.error;
      mOnError = c.light.onError;
      mSurface = c.light.surface;
      mOnSurface = c.light.onSurface;
      mSurfaceVariant = c.light.surfaceVariant;
      mOnSurfaceVariant = c.light.onSurfaceVariant;
      mOutline = c.light.outline;
      mShadow = c.light.shadow;
      mHover = c.light.hover;
      mOnHover = c.light.onHover;
      terminal = c.light.terminal;
    };
  };

  privacyIndicatorSettings = builtins.toJSON {
    activeIconColor = c.dark.onSurface;
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
    ".config/noctalia/plugins/tailscale" = {
      source = "${noctalia-plugins}/tailscale";
      recursive = true;
    };
    ".config/noctalia/plugins/privacy-indicator" = {
      source = "${noctalia-plugins}/privacy-indicator";
      recursive = true;
    };
    ".config/noctalia/plugins/tailscale/settings.json".text = builtins.toJSON {
      refreshInterval = 5000;
      compactMode = true;
      showIpAddress = false;
      showPeerCount = false;
      hideDisconnected = false;
      terminalCommand = "kitty";
      pingCount = 5;
      defaultPeerAction = "copy-ip";
    };
    ".config/noctalia/plugins/privacy-indicator/settings.json".text = privacyIndicatorSettings;
    ".config/noctalia/plugins/polkit-agent" = {
      source = "${noctalia-plugins}/polkit-agent";
      recursive = true;
    };
  };
}
