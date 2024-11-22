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
        imports = [ ./yabai.nix ./skhd.nix ];

        nixpkgs.config.allowUnfree = true;

        environment.variables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
        };
        environment.systemPackages = [
          pkgs.niv
          pkgs.jdk23
          pkgs.ocaml
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
          pkgs.skhd
          pkgs.hub
        ];

        services.nix-daemon.enable = true;
        services.postgresql = {
          enable = true;
          package = pkgs.postgresql_16;
        };

        users.users.vadymbiliuk = {
          name = username;
          home = "/Users/vadymbiliuk";
        };

        fonts.packages =
          [ (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

        homebrew = {
          enable = true;
          brews = [ "mas" "libjpeg" "openjpeg" ];
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
            "unnaturalscrollwheels"
            "tableplus"
            "docker"
            "zed"
            "battle-net"
            "postman"
            "hstracker"
          ];
          masApps = {
            "1Password for Safari" = 1569813296;
            "Dark Reader for Safari" = 1438243180;
          };
          onActivation.cleanup = "zap";
          onActivation.autoUpdate = true;
          onActivation.upgrade = true;
        };

        system.defaults = {
          dock.persistent-apps = [
            "/Applications/Safari.app/"
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
