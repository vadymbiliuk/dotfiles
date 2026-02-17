{ config, pkgs, lib, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in {
  imports = [ ./base.nix (import ../system/overlays.nix { inherit inputs; }) ];

  system.defaults = {
    dock = {
      "persistent-apps" = [
        "/Applications/Firefox.app"
        "/Applications/Telegram.app"
        "/Applications/Ghostty.app"
        "/Applications/Obsidian.app"
        "/System/Applications/Calendar.app"
        "/System/Applications/Mail.app"
      ];
      "show-recents" = false;
      "static-only" = false;
      tilesize = 64;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
    };

    loginwindow = { GuestEnabled = false; };

    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 1;
      InitialKeyRepeat = 10;
    };
  };

  services.aerospace = {
    enable = true;
    settings = {
      on-window-detected = [
        {
          "if" = { app-id = "com.bitwarden.desktop"; };
          run = "layout floating";
          check-further-callbacks = false;
        }
      ];

      workspace-to-monitor-force-assignment = {
        "1" = "main";
        "2" = "main";
        "3" = "main";
        "4" = "main";
        "5" = "main";
        "6" = [ "secondary" "^XG27ACDNG.*" "2" ];
        "7" = [ "secondary" "^XG27ACDNG.*" "2" ];
        "8" = [ "secondary" "^XG27ACDNG.*" "2" ];
        "9" = [ "secondary" "^XG27ACDNG.*" "2" ];
        "10" = [ "secondary" "^XG27ACDNG.*" "2" ];
      };

      gaps = {
        inner.horizontal = 8;
        inner.vertical = 8;
        outer.left = 12;
        outer.bottom = 12;
        outer.top = 12;
        outer.right = 12;
      };

      mode.main.binding = {
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";

        alt-shift-minus = "resize smart -50";
        alt-shift-equal = "resize smart +50";

        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";
        alt-0 = "workspace 10";

        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        alt-shift-8 = "move-node-to-workspace 8";
        alt-shift-9 = "move-node-to-workspace 9";
        alt-shift-0 = "move-node-to-workspace 10";

        alt-tab = "workspace-back-and-forth";
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        alt-b = "layout tiles horizontal vertical";
        alt-shift-comma = "layout accordion horizontal vertical";

        alt-shift-f = "fullscreen";

        alt-shift-semicolon = "mode service";
      };

      mode.service.binding = {
        r = [ "flatten-workspace-tree" "mode main" ];
        f = [ "layout floating tiling" "mode main" ];
        backspace = [ "close-all-windows-but-current" "mode main" ];

        alt-shift-h = [ "join-with left" "mode main" ];
        alt-shift-j = [ "join-with down" "mode main" ];
        alt-shift-k = [ "join-with up" "mode main" ];
        alt-shift-l = [ "join-with right" "mode main" ];

        esc = "mode main";
      };
    };
  };

  environment.systemPackages = with pkgs; [ unstable.claude-code ];

  homebrew = {
    enable = true;
    brews = [
      "mas"
      "libjpeg"
      "openjpeg"
      "gmp"
      "libev"
      "openssl"
      "zlib"
      "c-ares"
      "pkg-config"
      "pkgconf"
      "redis"
      "snappy"
      "mecab-ko"
      "mecab-ko-dic"
      "pyenv"
      "rbenv"
      "ruby-build"
      "libpq"
      "postgresql@17"
      "imagemagick"
      "vips"
      "mkcert"
      "nss"
      "libiconv"
      "pgvector"
    ];
    casks = [
      "bitwarden"
      "the-unarchiver"
      "firefox"
      "discord"
      "spotify"
      "nordvpn"
      "raycast"
      "fork"
      "telegram"
      "steam"
      "unnaturalscrollwheels"
      "tableplus"
      "zed"
      "battle-net"
      "insomnia"
      "bruno"
      "hstracker"
      "obsidian"
      "kitty"
      "ghostty"
      "teamspeak-client"
      "epic-games"
      "obs"
      "docker-desktop"
      "google-chrome"
      "slack"
      "microsoft-word"
      "bitwarden"
    ];
    masApps = { "MeetingBar" = 1532419400; };
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  nix.enable = false;

  determinate-nix.customSettings = {
    eval-cores = 0;
    extra-experimental-features =
      [ "nix-command" "flakes" "build-time-fetch-tree" "parallel-eval" ];
  };
}
