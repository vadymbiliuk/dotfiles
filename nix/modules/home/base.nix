{ config, pkgs, lib, ... }:

{
  imports = [ ./bitwarden.nix ./ghostty-themes.nix ./fish.nix ./zsh.nix ];

  home.enableNixpkgsReleaseCheck = false;

  home.sessionVariables = {
    QML2_IMPORT_PATH =
      "/run/current-system/sw/lib/qt-6/qml:/run/current-system/sw/lib/qt-5.15.17/qml:$QML2_IMPORT_PATH";
  };

  home.packages = with pkgs;
    [
      unzip
      fastfetch
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
      tmux
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
        black = "#1c1e23";
        red = "#b0b0b0";
        green = "#d6d6d6";
        yellow = "#b0b0b0";
        blue = "#888888";
        purple = "#999999";
        cyan = "#a2a2a2";
        white = "#d6d6d6";
        bright-black = "#555555";
        bright-red = "#b5b5b5";
        bright-green = "#deeeed";
        bright-yellow = "#b5b5b5";
        bright-blue = "#ababab";
        bright-purple = "#b0b0b0";
        bright-cyan = "#b5b5b5";
        bright-white = "#deeeed";
      };
      character = {
        success_symbol = "[->](bold white)";
        error_symbol = "[->](bold red)";
      };
    };
  };

  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then
      (pkgs.runCommand "ghostty-dummy" { meta.mainProgram = "ghostty"; } ''
        mkdir -p $out/bin
        touch $out/bin/ghostty
        chmod +x $out/bin/ghostty
      '')
    else
      pkgs.ghostty;

    settings = {
      theme = "lucklaster";

      font-family = "BerkeleyMonoMinazuki Nerd Font Mono";
      font-size = if pkgs.stdenv.isDarwin then 22 else 18;
      font-feature = [ "+liga" "+calt" "+dlig" ];

      window-padding-x = 14;
      window-padding-y = 14;
      resize-overlay = "never";

      cursor-style = "block";
      cursor-style-blink = true;

      bold-is-bright = true;
      link-url = true;
      mouse-hide-while-typing = true;
      window-vsync = true;

      window-decoration = true;
      macos-titlebar-style = "tabs";

      scrollback-limit = 4294967295;
      shell-integration = "fish";
      shell-integration-features = "cursor,sudo,title";

      background-opacity = 0.8;
      background-blur = 250;

      macos-option-as-alt = !pkgs.stdenv.isDarwin;

      keybind = let mod = if pkgs.stdenv.isDarwin then "cmd" else "alt";
      in [
        "shift+enter=text:\\\\n"
        "${mod}+t=new_tab"
        "shift+insert=paste_from_clipboard"
        "control+insert=copy_to_clipboard"
      ];
    };
  };

}

