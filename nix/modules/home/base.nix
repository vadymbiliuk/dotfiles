{ config, pkgs, lib, ... }:

{
  home.enableNixpkgsReleaseCheck = false;
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

    initExtra = ''
      ZSH_DISABLE_COMPFIX=true
      export EDITOR=nvim
      export XDG_CONFIG_HOME="$HOME/.config"

      eval "$(zoxide init zsh)"

      z() {
        __zoxide_z "$@"
      }

      export DIRENV_LOG_FORMAT=""
      if command -v direnv >/dev/null 2>&1; then
        eval "$(direnv hook zsh)"
      fi

      ${lib.optionalString pkgs.stdenv.isDarwin ''
        export PATH="/opt/homebrew/bin:$PATH"
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
        pokemonthink --pokemon Gengar -N "Hello!"
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
    userName = "Vadym Biliuk";
    userEmail = "vadym.biliuk@gmail.com";

    extraConfig = {
      core.excludesFile = "~/.config/git/ignore";
      pull.rebase = true;
      init.defaultBranch = "main";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
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

      palette = [
        "0=#080808"
        "1=#d70000"
        "2=#789978"
        "3=#ffaa88"
        "4=#7788aa"
        "5=#d7007d"
        "6=#708090"
        "7=#deeeed"
        "8=#444444"
        "9=#d70000"
        "10=#789978"
        "11=#ffaa88"
        "12=#7788aa"
        "13=#d7007d"
        "14=#708090"
        "15=#deeeed"
      ];
      background = "0a0a0a";
      foreground = "deeeed";
      cursor-color = "deeeed";
      cursor-text = "0a0a0a";
      selection-background = "7a7a7a";
      selection-foreground = "0a0a0a";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        extraOptions = {
          IdentityAgent = if pkgs.stdenv.isDarwin then
            ''
              "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"''
          else
            "~/.1password/agent.sock";
        };
      };
    };
  };

}

