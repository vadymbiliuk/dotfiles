{ config, pkgs, lib, ... }:

let
  theme = import ../themes/monochrome.nix;
  t = theme.colors.dark.terminal;
in
{
  imports = [ ./bitwarden.nix ./fish.nix ./zsh.nix ];

  home.enableNixpkgsReleaseCheck = false;

  home.sessionVariables = {
    QML2_IMPORT_PATH =
      "/run/current-system/sw/lib/qt-6/qml:/run/current-system/sw/lib/qt-5.15.17/qml:$QML2_IMPORT_PATH";
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      modules = [
        "separator"
        "os"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "display"
        "wm"
        "theme"
        "icons"
        "cursor"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "swap"
        "disk"
        "break"
        "colors"
      ];
    };
  };

  home.packages = with pkgs;
    [
      unzip
      btop
      act
      starship
      openjpeg
      libjpeg
      zlib
      xz
      hub
      gh
      jq
      pkg-config
      tree-sitter
      gnused
      ripgrep
      fzf
      fd
      lazygit
      zellij
      gnumake
      coreutils
      pokemonsay
      zoxide
    ] ++ lib.optionals pkgs.stdenv.isDarwin [ mkalias ];

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "Vadym Biliuk";
      user.email = "vadym.biliuk@gmail.com";
      core.excludesFile = "~/.config/git/ignore";
      pull.rebase = true;
      init.defaultBranch = "main";
      rerere.enabled = true;
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      palette = "monochrome";
      palettes.monochrome = {
        black = t.normal.black;
        red = t.normal.white;
        green = t.bright.white;
        yellow = t.normal.white;
        blue = t.bright.red;
        purple = t.bright.yellow;
        cyan = t.bright.blue;
        white = t.bright.white;
        bright-black = t.normal.red;
        bright-red = t.bright.cyan;
        bright-green = t.foreground;
        bright-yellow = t.bright.cyan;
        bright-blue = t.bright.magenta;
        bright-purple = t.normal.white;
        bright-cyan = t.bright.cyan;
        bright-white = t.foreground;
      };
      character = {
        success_symbol = "[->](bold white)";
        error_symbol = "[->](bold red)";
      };
    };
  };

  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    attachExistingSession = true;
    exitShellOnExit = true;
    settings = {
      layout_dir = "${./zellij-layouts}";
      default_layout = "claude";
      default_mode = "locked";
      mouse_mode = true;
      pane_frames = false;
      session_serialization = true;
      serialization_interval = 1;
      scroll_buffer_size = 50000;
    };
    extraConfig = ''
      themes {
          monochrome {
              fg "${t.foreground}"
              bg "${t.background}"
              black "${t.normal.black}"
              red "${t.normal.red}"
              green "${t.normal.green}"
              yellow "${t.normal.yellow}"
              blue "${t.normal.blue}"
              magenta "${t.normal.magenta}"
              cyan "${t.normal.cyan}"
              white "${t.normal.white}"
              orange "${t.bright.red}"
          }
      }
      theme "monochrome"
      keybinds {
          locked {
              bind "Alt 1" { GoToTab 1; }
              bind "Alt 2" { GoToTab 2; }
              bind "Alt 3" { GoToTab 3; }
              bind "Alt 4" { GoToTab 4; }
              bind "Alt 5" { GoToTab 5; }
              bind "Alt 6" { GoToTab 6; }
              bind "Alt 7" { GoToTab 7; }
              bind "Alt 8" { GoToTab 8; }
              bind "Alt 9" { GoToTab 9; }
              bind "Alt n" { NewTab; }
              bind "Alt h" { GoToPreviousTab; }
              bind "Alt l" { GoToNextTab; }
              bind "Alt c" { Run "claude" "--resume" { direction "Down"; }; }
          }
      }
    '';
  };

}
