{ config, pkgs, lib, ... }:

{
  imports = [ ./bitwarden.nix ./ghostty-themes.nix ];

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

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;

    shellAliases = {
      vim = "nvim";
      v = "nvim";
      ga = "git add";
      gs = "git status";
      gc = "git checkout";
      gcm = "git commit";
      ls = "ls --color";
      lg = "lazygit";

      tm = "tmux";
      tma = "tmux attach";
      tmls = "tmux list-sessions";
      tmks = "tmux kill-session -t";
      tmn = "tmux new-session -s";

      zi = "__zoxide_zi";
      za = "zoxide add";
      zq = "zoxide query";
      zr = "zoxide remove";

};

    initContent = ''
      ZSH_DISABLE_COMPFIX=true
      export EDITOR=nvim
      export XDG_CONFIG_HOME="$HOME/.config"
      export QML2_IMPORT_PATH="/run/current-system/sw/lib/qt-6/qml:/run/current-system/sw/lib/qt-5.15.17/qml:$QML2_IMPORT_PATH"

      eval "$(zoxide init zsh)"

      z() {
        __zoxide_z "$@"
      }

      export DIRENV_LOG_FORMAT=""
      if command -v direnv >/dev/null 2>&1; then
        eval "$(direnv hook zsh)"
      fi

      export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"

      ${lib.optionalString pkgs.stdenv.isDarwin ''
        export PATH="/opt/homebrew/bin:$PATH"
        export CC="gcc"
        export CXX="g++"
        if command -v pyenv >/dev/null 2>&1; then
          export PYENV_ROOT="$HOME/.pyenv"
          export PATH="$PYENV_ROOT/bin:$PATH"
          eval "$(pyenv init -)"
        fi
        if command -v rbenv >/dev/null 2>&1; then
          export RBENV_ROOT="$HOME/.rbenv"
          export PATH="$RBENV_ROOT/bin:$PATH"
          eval "$(rbenv init -)"
        fi
      ''}

      if command -v pokemonsay >/dev/null 2>&1; then
        hour=$(date +%H)
        if [ $hour -ge 5 ] && [ $hour -lt 12 ]; then
          greeting="おはよう"
        elif [ $hour -ge 12 ] && [ $hour -lt 18 ]; then
          greeting="こんにちは"
        else
          greeting="こんばんは"
        fi
        pokemonthink --pokemon Gengar -N "$greeting"
      fi
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "gcloud" "gh" "git-commit" "ssh" ];
    };
  };

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
        # Remap all standard colors to grayscale
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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
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
      shell-integration = "zsh";
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

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

}

