{
  description = "Vadym's Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager, ... }:
    let
      username = "vadymbiliuk";
      configuration = { pkgs, ... }: {
        nixpkgs.config.allowUnfree = true;

        environment.systemPackages = [
          pkgs.jdk11
          pkgs.opam
          pkgs.lldb
          pkgs.cmake
          pkgs.gettext
          pkgs.starship
          pkgs.openjpeg
          pkgs.libjpeg
          pkgs.zlib
          pkgs.xz
          pkgs.mkalias
          pkgs.ffmpeg
          pkgs.postgresql_16
          pkgs.yabai
        ];

        services.postgresql = {
          enable = true;
          package = pkgs.postgresql_16;
        };

        services.yabai = {
          enable = true;
          config = {
            focus_follows_mouse = "autoraise";
            mouse_follows_focus = "on";
            window_placement = "second_child";
            window_opacity = "off";
            top_padding = 12;
            bottom_padding = 12;
            left_padding = 12;
            right_padding = 12;
            window_gap = 10;
          };
          extraConfig = ''
            yabai -m config mouse_modifier alt
            yabai -m config mouse_action1 move
            yabai -m config mouse_action2 resize

            yabai -m mouse_drop_action swap

            yabai -m rule --add app="^System Settings$" manage=off
            yabai -m rule --add app="^Calculator$" manage=off
            yabai -m rule --add app="^Karabiner-Elements$" manage=off
            yabai -m rule --add app="^QuickTime Player$" manage=off
            yabai -m rule --add app="^1Password$" manage=off
          '';
        };

        users.users.vadymbiliuk = {
          name = username;
          home = "/Users/vadymbiliuk";
        };

        fonts.packages =
          [ (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

        homebrew = {
          enable = true;
          brews = [
            "mas"
            "libjpeg"
            "libtiff"
            "little-cms2"
            "openjpeg"
            "webp"
            "openssl"
            "ca-certificates"
            "curl"
          ];
          casks = [
            "google-chrome"
            "the-unarchiver"
            "1password"
            "discord"
            "spotify"
            "nordvpn"
            "raycast"
            "fork"
            "telegram"
            "steam"
          ];
          masApps = { };
          onActivation.cleanup = "zap";
          onActivation.autoUpdate = true;
          onActivation.upgrade = true;
        };

        system.defaults = {
          dock.persistent-apps = [
            "/Applications/Google Chrome.app"
            "/Applications/Telegram.app"
            "${pkgs.kitty}/Applications/Kitty.app"
            "${pkgs.obsidian}/Applications/Obsidian.app"
            "/System/Applications/Calendar.app"
            "/System/Applications/Mail.app"
          ];
          dock.show-recents = false;
          dock.static-only = false;
          finder.AppleShowAllExtensions = true;
          finder.AppleShowAllFiles = true;
          loginwindow.GuestEnabled = false;
          NSGlobalDomain.AppleICUForce24HourTime = true;
          NSGlobalDomain.AppleInterfaceStyle = "Dark";
          NSGlobalDomain.KeyRepeat = 1;
          NSGlobalDomain.InitialKeyRepeat = 10;
        };

        services.nix-daemon.enable = true;

        nix.settings.experimental-features = "nix-command flakes";

        programs.zsh.enable = true; # default shell on catalina

        system.configurationRevision = self.rev or self.dirtyRev or null;

        system.stateVersion = 5;

        nixpkgs.hostPlatform = "aarch64-darwin";
      };
    in {
      darwinConfigurations."chrollo" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "vadymbiliuk";
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.vadymbiliuk = import ./home.nix;
          }
        ];
      };

      darwinPackages = self.darwinConfigurations."chrollo".pkgs;
    };
}
