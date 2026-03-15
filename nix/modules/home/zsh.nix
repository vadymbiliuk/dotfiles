{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = false;
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
}
